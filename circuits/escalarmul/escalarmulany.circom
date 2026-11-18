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
pragma circom 2.1.5;

include "../montgomery.circom";
include "../babyjub.circom";
include "../comparators.circom";
include "../buses.circom";

// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617.

/*
    Variable-base scalar multiplication on Baby Jubjub: pout = (sum_i e[i]*2^i) * pin,
    where pin is a signal (known only at proving time).

    LSB-first binary double-and-add, using the cheap but incomplete Montgomery
    formulas (see montgomery.circom). Each bit costs about 9 constraints
    (double 4 + add 3 + select 2).
*/

// pout = sel ? pin[1] : pin[0]
template MultiplexorEdwards2() {
    input signal {binary} sel;
    input Point {babyedwards} pin[2];
    output Point {babyedwards} pout;

    pout.x <== (pin[1].x - pin[0].x)*sel + pin[0].x;
    pout.y <== (pin[1].y - pin[0].y)*sel + pin[0].y;
}

template MultiplexorMontgomery2() {
    input signal {binary} sel;
    input Point {base, min_scalar, max_scalar, babymontgomery} pin0, pin1;
    output Point {base, min_scalar, max_scalar, babymontgomery} pout;

    assert(pin0.base == pin1.base);
    pout.base = pin0.base;
    pout.min_scalar = pin0.min_scalar < pin1.min_scalar ? pin0.min_scalar : pin1.min_scalar;
    pout.max_scalar = pin0.max_scalar > pin1.max_scalar ? pin0.max_scalar : pin1.max_scalar;

    pout.x <== (pin1.x - pin0.x)*sel + pin0.x;
    pout.y <== (pin1.y - pin0.y)*sel + pin0.y;
}


/*
    One double-and-add step, in Montgomery form:
        dblOut = 2 * dblIn
        addOut = sel ? addIn + dblOut : addIn
*/

template BitElementMulAny() {
    input signal {binary} sel;
    input Point {base, min_scalar, max_scalar, babymontgomery} dblIn;
    input Point {base, min_scalar, max_scalar, babymontgomery} addIn;
    output Point {base, min_scalar, max_scalar, babymontgomery} dblOut;
    output Point {base, min_scalar, max_scalar, babymontgomery} addOut;

    component doubler = MontgomeryDouble();
    component adder = MontgomeryAdd();
    component selector = MultiplexorMontgomery2();


    sel ==> selector.sel;

    dblIn ==> doubler.pin;
    doubler.pout ==> adder.pin1;
    addIn ==> adder.pin2;
    addIn ==> selector.pin0;
    adder.pout ==> selector.pin1;


    doubler.pout ==> dblOut;
    selector.pout ==> addOut;

}

/*
    pout = (sum_i e[i]*2^i) * pin, with pin and pout in Edwards form.
    dbl = 2^(n-1) * pin is in Montgomery form and is linked to the next segment.
    n = 1 is handled separately: pout = e[0] ? pin : O.

    The identity cannot be represented in Montgomery form, so the accumulator
    starts at pin instead of O and processes bits e[1..n-1]:
        acc = pin + sum_{i>=1} e[i]*2^i * pin
    The extra pin is then absorbed by bit 0: pout = e[0] ? acc : acc - pin, where
    the subtraction uses the complete BabyAdd.

    Safety (pin of prime order l, pin != O): at step i the accumulator is k*pin
    with 1 <= k <= 2^i - 1 and the doubler holds 2^i * pin. They are never equal,
    and never opposite while k + 2^i < l, which holds for n <= 250.
*/

template SegmentMulAny(n, Id) {
    input signal {binary}  e[n];
    input Point {insubgroupl, babyedwards} pin;
    output Point {babyedwards} pout;
    output Point {base, min_scalar, max_scalar, babymontgomery} dbl;

    component bits[n-1];

    component e2m = Edwards2Montgomery(Id);

    pin ==> e2m.pin;

    if (n == 1) {
        // pout = e[0] ? pin : O
        pout.x <== pin.x*e[0];
        pout.y <== (pin.y - 1)*e[0] + 1;
        dbl <== e2m.pout;
    } else {
        var i;

        bits[0] = BitElementMulAny();
        e2m.pout ==> bits[0].dblIn;
        e2m.pout ==> bits[0].addIn;
        e[1] ==> bits[0].sel;

        for (i=1; i<n-1; i++) {
            bits[i] = BitElementMulAny();

            bits[i-1].dblOut ==> bits[i].dblIn;
            bits[i-1].addOut ==> bits[i].addIn;
            e[i+1] ==> bits[i].sel;
        }

        bits[n-2].dblOut ==> dbl;

        component m2e = Montgomery2Edwards();

        bits[n-2].addOut ==> m2e.pin;

        component eadder = BabyAdd();

        m2e.pout ==> eadder.pin1;
        Point {babyedwards} inv_pin;
        inv_pin.x <== -pin.x;
        inv_pin.y <== pin.y;
        inv_pin ==> eadder.pin2;

        component lastSel = MultiplexorEdwards2();

        e[0] ==> lastSel.sel;
        eadder.pout ==> lastSel.pin[0];
        m2e.pout ==> lastSel.pin[1];

        lastSel.pout ==> pout;
    }
}

/*
    pout = (sum_i e[i]*2^i) * pin, with pin and pout in Edwards form.

    pin must have order l (tag insubgroupl). For a pin that may also be the
    identity (0, 1), use EscalarMulAnyOrUnit.

    The scalar is split into segments of 148 bits, well within the bound of
    SegmentMulAny. Segment s uses base 2^(148*s) * pin, obtained by doubling the
    previous segment's dbl, and the segment results are summed with BabyAdd,
    which is complete.
*/

template EscalarMulAny(n) {
    input signal {binary} e[n];              // Input in binary format
    input Point {insubgroupl, babyedwards} pin; // Point (Twisted format) of order l
    output Point {babyedwards} pout;           // Point (Twisted format)

    var nsegments = (n-1)\148 +1;
    var nlastsegment = n - (nsegments-1)*148;

    component segments[nsegments];
    component doublers[nsegments-1];
    component m2e[nsegments-1];
    component adders[nsegments-1];

    var s;
    var i;
    var nseg;

    for (s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? 148 : nlastsegment;

        segments[s] = SegmentMulAny(nseg, s);

        for (i=0; i<nseg; i++) {
            e[s*148+i] ==> segments[s].e[i];
        }

        if (s==0) {
            segments[s].pin <== pin;
        } else {
            doublers[s-1] = MontgomeryDouble();
            m2e[s-1] = Montgomery2Edwards();
            adders[s-1] = BabyAdd();

            segments[s-1].dbl ==> doublers[s-1].pin;
            doublers[s-1].pout ==> m2e[s-1].pin;
            m2e[s-1].pout ==> segments[s].pin;

            if (s==1) {
                segments[s-1].pout ==> adders[s-1].pin1;
            } else {
                adders[s-2].pout ==> adders[s-1].pin1;
            }
            segments[s].pout ==> adders[s-1].pin2;
        }
    }

    if (nsegments == 1) {
        segments[0].pout ==> pout;
    } else {
        adders[nsegments-2].pout ==> pout;
    }
}

/*
    pout = isunit ? alt : pin, with isunit = (pin.x == 0).

    pin has order l or it is the identity (tag insubgrouplorunit). The only point
    of that kind with x = 0 is the identity (0, 1), so pout always has order l:
    it is pin if pin is not the identity, and alt otherwise.
*/

template MultiplexorSubgroupL() {
    input Point {insubgrouplorunit, babyedwards} pin;
    input Point {insubgroupl, babyedwards} alt;
    output signal {binary} isunit;
    output Point {insubgroupl, babyedwards} pout;

    isunit <== IsZero()(pin.x);

    pout.x <== (alt.x - pin.x)*isunit + pin.x;
    pout.y <== (alt.y - pin.y)*isunit + pin.y;
}

/*
    pout = (sum_i e[i]*2^i) * pin, with pin and pout in Edwards form.

    pin has order l or it is the identity (tag insubgrouplorunit), e.g. 8*A
    computed with CheckandAddSubgroupLOrUnit. If pin is the identity, the
    multiplication runs on BASE8 instead (EscalarMulAny needs a point of order l)
    and the output is forced to O = (0, 1).
*/

template EscalarMulAnyOrUnit(n) {
    input signal {binary} e[n];              // Input in binary format
    input Point {insubgrouplorunit, babyedwards} pin; // Point (Twisted format) of order l or (0, 1)
    output Point {babyedwards} pout;           // Point (Twisted format)

    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    Point {insubgroupl, babyedwards} base8 <== SubgroupLOnlyCheckFix(BASE8)();

    // Use BASE8 if pin is the identity
    component sel = MultiplexorSubgroupL();
    sel.pin <== pin;
    sel.alt <== base8;

    Point {babyedwards} mul <== EscalarMulAny(n)(e, sel.pout);

    // Force O = (0, 1) if pin is the identity
    pout.x <== mul.x*(1-sel.isunit);
    pout.y <== mul.y+(1-mul.y)*sel.isunit;
}
