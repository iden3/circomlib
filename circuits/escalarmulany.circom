/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/
pragma circom 2.0.0;

include "babyjub_params.circom";
include "montgomery.circom";
include "babyjub.circom";
include "comparators.circom";

/*
    Variable-base scalar multiplication on Baby Jubjub: out = (sum_i e[i]*2^i) * p,
    where p is a signal (known only at proving time).

    LSB-first binary double-and-add, using the cheap but incomplete Montgomery
    formulas (see montgomery.circom). Each bit costs about 9 constraints
    (double 4 + add 3 + select 2).
*/

// out = sel ? in[1] : in[0]. sel must be a bit (not checked).
template Multiplexor2() {
    signal input sel;
    signal input in[2][2];
    signal output out[2];

    out[0] <== (in[1][0] - in[0][0])*sel + in[0][0];
    out[1] <== (in[1][1] - in[0][1])*sel + in[0][1];
}

/*
    One double-and-add step, in Montgomery form:
        dblOut = 2 * dblIn
        addOut = sel ? addIn + dblOut : addIn
*/
template BitElementMulAny() {
    signal input sel;
    signal input dblIn[2];
    signal input addIn[2];
    signal output dblOut[2];
    signal output addOut[2];

    component doubler = MontgomeryDouble();
    component adder = MontgomeryAdd();
    component selector = Multiplexor2();

    selector.sel <== sel;

    doubler.in[0] <== dblIn[0];
    doubler.in[1] <== dblIn[1];
    adder.in1[0] <== doubler.out[0];
    adder.in1[1] <== doubler.out[1];
    adder.in2[0] <== addIn[0];
    adder.in2[1] <== addIn[1];
    selector.in[0][0] <== addIn[0];
    selector.in[0][1] <== addIn[1];
    selector.in[1][0] <== adder.out[0];
    selector.in[1][1] <== adder.out[1];

    dblOut[0] <== doubler.out[0];
    dblOut[1] <== doubler.out[1];
    addOut[0] <== selector.out[0];
    addOut[1] <== selector.out[1];
}

/*
    out = (sum_i e[i]*2^i) * p, with p and out in Edwards form.
    dbl = 2^(n-1) * p is in Montgomery form and is linked to the next segment.
    n = 1 is handled separately: out = e[0] ? p : O.

    The identity cannot be represented in Montgomery form, so the accumulator
    starts at p instead of O and processes bits e[1..n-1]:
        acc = p + sum_{i>=1} e[i]*2^i * p
    The extra p is then absorbed by bit 0: out = e[0] ? acc : acc - p, where the
    subtraction uses the complete BabyAdd.

    Safety (p of prime order l, p != O): at step i the accumulator is k*p with
    1 <= k <= 2^i - 1 and the doubler holds 2^i * p. They are never equal, and
    never opposite while k + 2^i < l, which holds for n <= 250.
*/
template SegmentMulAny(n) {
    signal input e[n];
    signal input p[2];
    signal output out[2];
    signal output dbl[2];

    component bits[n - 1];

    component e2m = Edwards2Montgomery();
    e2m.in[0] <== p[0];
    e2m.in[1] <== p[1];

    if (n == 1) {
        // out = e[0] ? p : O
        out[0] <== p[0]*e[0];
        out[1] <== (p[1] - 1)*e[0] + 1;

        dbl[0] <== e2m.out[0];
        dbl[1] <== e2m.out[1];
    } else {
        // acc = dbl = p
        bits[0] = BitElementMulAny();
        bits[0].dblIn[0] <== e2m.out[0];
        bits[0].dblIn[1] <== e2m.out[1];
        bits[0].addIn[0] <== e2m.out[0];
        bits[0].addIn[1] <== e2m.out[1];
        bits[0].sel <== e[1];

        for (var i = 1; i < n - 1; i++) {
            bits[i] = BitElementMulAny();
            bits[i].dblIn[0] <== bits[i - 1].dblOut[0];
            bits[i].dblIn[1] <== bits[i - 1].dblOut[1];
            bits[i].addIn[0] <== bits[i - 1].addOut[0];
            bits[i].addIn[1] <== bits[i - 1].addOut[1];
            bits[i].sel <== e[i + 1];
        }

        dbl[0] <== bits[n - 2].dblOut[0];
        dbl[1] <== bits[n - 2].dblOut[1];

        component m2e = Montgomery2Edwards();
        m2e.in[0] <== bits[n - 2].addOut[0];
        m2e.in[1] <== bits[n - 2].addOut[1];

        // acc - p
        component eadder = BabyAdd();
        eadder.x1 <== m2e.out[0];
        eadder.y1 <== m2e.out[1];
        eadder.x2 <== -p[0];
        eadder.y2 <== p[1];

        // out = e[0] ? acc : acc - p
        component lastSel = Multiplexor2();
        lastSel.sel <== e[0];
        lastSel.in[0][0] <== eadder.xout;
        lastSel.in[0][1] <== eadder.yout;
        lastSel.in[1][0] <== m2e.out[0];
        lastSel.in[1][1] <== m2e.out[1];

        out[0] <== lastSel.out[0];
        out[1] <== lastSel.out[1];
    }
}

/*
    out = (sum_i e[i]*2^i) * p, with p and out in Edwards form.

    e must be bits (e.g. from Num2Bits). This template does not check it.
    p must be in the prime-order subgroup (e.g. clear the cofactor first, as the
    EdDSA verifiers do by multiplying by 8). The identity is handled: if
    p[0] == 0, the computation runs on BASE8 instead (Edwards2Montgomery would
    divide by zero) and the output is forced to O = (0, 1).

    The scalar is split into segments of 148 bits, well within the bound of
    SegmentMulAny. Segment s uses base 2^(148*s) * p, obtained by doubling the
    previous segment's dbl, and the segment results are summed with BabyAdd,
    which is complete.
*/
template EscalarMulAny(n) {
    signal input e[n];
    signal input p[2];
    signal output out[2];

    var nsegments = (n - 1) \ 148 + 1;
    var nlastsegment = n - (nsegments - 1)*148;

    component segments[nsegments];
    component doublers[nsegments - 1];
    component m2e[nsegments - 1];
    component adders[nsegments - 1];

    component zeropoint = IsZero();
    zeropoint.in <== p[0];

    var BASE8[2] = babyjub_base8();

    for (var s = 0; s < nsegments; s++) {
        var nseg = (s < nsegments - 1) ? 148 : nlastsegment;

        segments[s] = SegmentMulAny(nseg);

        for (var i = 0; i < nseg; i++) {
            segments[s].e[i] <== e[s*148 + i];
        }

        if (s == 0) {
            // Use BASE8 if p is the identity
            segments[s].p[0] <== p[0] + (BASE8[0] - p[0])*zeropoint.out;
            segments[s].p[1] <== p[1] + (BASE8[1] - p[1])*zeropoint.out;
        } else {
            doublers[s - 1] = MontgomeryDouble();
            m2e[s - 1] = Montgomery2Edwards();
            adders[s - 1] = BabyAdd();

            doublers[s - 1].in[0] <== segments[s - 1].dbl[0];
            doublers[s - 1].in[1] <== segments[s - 1].dbl[1];

            m2e[s - 1].in[0] <== doublers[s - 1].out[0];
            m2e[s - 1].in[1] <== doublers[s - 1].out[1];

            segments[s].p[0] <== m2e[s - 1].out[0];
            segments[s].p[1] <== m2e[s - 1].out[1];

            if (s == 1) {
                adders[s - 1].x1 <== segments[s - 1].out[0];
                adders[s - 1].y1 <== segments[s - 1].out[1];
            } else {
                adders[s - 1].x1 <== adders[s - 2].xout;
                adders[s - 1].y1 <== adders[s - 2].yout;
            }
            adders[s - 1].x2 <== segments[s].out[0];
            adders[s - 1].y2 <== segments[s].out[1];
        }
    }

    // Force O = (0, 1) if p is the identity
    if (nsegments == 1) {
        out[0] <== segments[0].out[0]*(1 - zeropoint.out);
        out[1] <== segments[0].out[1] + (1 - segments[0].out[1])*zeropoint.out;
    } else {
        out[0] <== adders[nsegments - 2].xout*(1 - zeropoint.out);
        out[1] <== adders[nsegments - 2].yout + (1 - adders[nsegments - 2].yout)*zeropoint.out;
    }
}
