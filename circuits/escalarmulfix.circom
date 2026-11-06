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

include "mux3.circom";
include "montgomery.circom";
include "babyjub.circom";

/*
    Fixed-base scalar multiplication on Baby Jubjub: out = (sum_i e[i]*2^i) * BASE.

    The scalar is processed in 3-bit windows, using the cheap but incomplete
    Montgomery formulas (see montgomery.circom). The windows are arranged so
    that those formulas never meet an exceptional case.
*/

/*
    One 3-bit window, in Montgomery form. With v = in[0] + 2*in[1] + 4*in[2]:
        out  = (1 + v) * base     (never the identity)
        out8 = 8 * base           (it is the next window's base)
    The table (1..8)*base is built with one double and six adds, and MultiMux3
    selects from it.
*/
template WindowMulFix() {
    signal input in[3];
    signal input base[2];
    signal output out[2];
    signal output out8[2];

    component mux = MultiMux3(2);
    mux.s[0] <== in[0];
    mux.s[1] <== in[1];
    mux.s[2] <== in[2];

    // mux.c[*][k] = (k + 1)*base
    component dbl2 = MontgomeryDouble();
    component adders[6];

    mux.c[0][0] <== base[0];
    mux.c[1][0] <== base[1];

    dbl2.in[0] <== base[0];
    dbl2.in[1] <== base[1];
    mux.c[0][1] <== dbl2.out[0];
    mux.c[1][1] <== dbl2.out[1];

    for (var k = 2; k < 8; k++) {
        adders[k - 2] = MontgomeryAdd();
        adders[k - 2].in1[0] <== base[0];
        adders[k - 2].in1[1] <== base[1];
        if (k == 2) {
            adders[k - 2].in2[0] <== dbl2.out[0];
            adders[k - 2].in2[1] <== dbl2.out[1];
        } else {
            adders[k - 2].in2[0] <== adders[k - 3].out[0];
            adders[k - 2].in2[1] <== adders[k - 3].out[1];
        }
        mux.c[0][k] <== adders[k - 2].out[0];
        mux.c[1][k] <== adders[k - 2].out[1];
    }

    out8[0] <== adders[5].out[0];
    out8[1] <== adders[5].out[1];

    out[0] <== mux.out[0];
    out[1] <== mux.out[1];
}

/*
    out = s * base, where s = sum_i v_i * 8^i and v_i is window i.
    base and out are in Edwards form. dbl = 8^nWindows * base is in Montgomery
    form and is linked to the next segment.

    Each window contributes (1 + v_i) * 8^i * base, so the sum carries an extra
    C = sum_i 8^i * base. To keep the Montgomery additions safe, the accumulator
    also starts at D = 2 * 8^nWindows * base. Then:
        adders:  D + sum_i (1 + v_i) * 8^i * base  = D + C + s*base
        cadders: C + D                                  (compensation)
        out    = (D + C + s*base) - (C + D)  = s*base   (complete BabyAdd)

    Safety: the accumulator is always >= D = 2*8^nWindows, and each window output
    is <= 8^nWindows, so the two inputs of an add are never equal. They are also
    never opposite (acc + w != 0 mod l) as long as acc + w < l, which holds for
    nWindows <= 82 (246 bits) but not for 83.
*/
template SegmentMulFix(nWindows) {
    signal input e[nWindows*3];
    signal input base[2];
    signal output out[2];
    signal output dbl[2];

    component e2m = Edwards2Montgomery();
    e2m.in[0] <== base[0];
    e2m.in[1] <== base[1];

    component windows[nWindows];
    component adders[nWindows];
    component cadders[nWindows];

    // D = 2 * 8^nWindows * base
    component dblLast = MontgomeryDouble();

    // Windows and compensation chain: cadders = base + 8*base + ... + 8^(nWindows-1)*base + D
    for (var i = 0; i < nWindows; i++) {
        windows[i] = WindowMulFix();
        cadders[i] = MontgomeryAdd();
        if (i == 0) {
            windows[i].base[0] <== e2m.out[0];
            windows[i].base[1] <== e2m.out[1];
            cadders[i].in1[0] <== e2m.out[0];
            cadders[i].in1[1] <== e2m.out[1];
        } else {
            windows[i].base[0] <== windows[i - 1].out8[0];
            windows[i].base[1] <== windows[i - 1].out8[1];
            cadders[i].in1[0] <== cadders[i - 1].out[0];
            cadders[i].in1[1] <== cadders[i - 1].out[1];
        }
        for (var j = 0; j < 3; j++) {
            windows[i].in[j] <== e[3*i + j];
        }
        if (i < nWindows - 1) {
            cadders[i].in2[0] <== windows[i].out8[0];
            cadders[i].in2[1] <== windows[i].out8[1];
        } else {
            dblLast.in[0] <== windows[i].out8[0];
            dblLast.in[1] <== windows[i].out8[1];
            cadders[i].in2[0] <== dblLast.out[0];
            cadders[i].in2[1] <== dblLast.out[1];
        }
    }

    // Accumulator chain: D + sum of window outputs
    for (var i = 0; i < nWindows; i++) {
        adders[i] = MontgomeryAdd();
        if (i == 0) {
            adders[i].in1[0] <== dblLast.out[0];
            adders[i].in1[1] <== dblLast.out[1];
        } else {
            adders[i].in1[0] <== adders[i - 1].out[0];
            adders[i].in1[1] <== adders[i - 1].out[1];
        }
        adders[i].in2[0] <== windows[i].out[0];
        adders[i].in2[1] <== windows[i].out[1];
    }

    component m2e = Montgomery2Edwards();
    m2e.in[0] <== adders[nWindows - 1].out[0];
    m2e.in[1] <== adders[nWindows - 1].out[1];

    component cm2e = Montgomery2Edwards();
    cm2e.in[0] <== cadders[nWindows - 1].out[0];
    cm2e.in[1] <== cadders[nWindows - 1].out[1];

    // out = acc - compensation
    component cAdd = BabyAdd();
    cAdd.x1 <== m2e.out[0];
    cAdd.y1 <== m2e.out[1];
    cAdd.x2 <== -cm2e.out[0];
    cAdd.y2 <== cm2e.out[1];

    out[0] <== cAdd.xout;
    out[1] <== cAdd.yout;

    dbl[0] <== windows[nWindows - 1].out8[0];
    dbl[1] <== windows[nWindows - 1].out8[1];
}

/*
    out = (sum_i e[i]*2^i) * BASE, with BASE a constant point in Edwards form.

    e must be bits (e.g. from Num2Bits). This template does not check it.
    The scalar is split into segments. Segment s uses base 2^(249*s) * BASE,
    obtained from the previous segment's dbl, and the segment results are
    summed with BabyAdd, which is complete.

    NOTE: segments are counted with 246 bits but filled with 249. As a result,
    n = 247..249 does not compile, and 249-bit segments exceed the safety bound
    of SegmentMulFix, which leaves some scalars unprovable.
*/
template EscalarMulFix(n, BASE) {
    signal input e[n];
    signal output out[2];

    var nsegments = (n - 1) \ 246 + 1;
    var nlastsegment = n - (nsegments - 1)*249;

    component segments[nsegments];
    component m2e[nsegments - 1];
    component adders[nsegments - 1];

    for (var s = 0; s < nsegments; s++) {
        var nseg = (s < nsegments - 1) ? 249 : nlastsegment;
        var nWindows = ((nseg - 1) \ 3) + 1;

        segments[s] = SegmentMulFix(nWindows);

        for (var i = 0; i < nseg; i++) {
            segments[s].e[i] <== e[s*249 + i];
        }
        for (var i = nseg; i < nWindows*3; i++) {
            segments[s].e[i] <== 0;   // padding
        }

        if (s == 0) {
            segments[s].base[0] <== BASE[0];
            segments[s].base[1] <== BASE[1];
        } else {
            m2e[s - 1] = Montgomery2Edwards();
            m2e[s - 1].in[0] <== segments[s - 1].dbl[0];
            m2e[s - 1].in[1] <== segments[s - 1].dbl[1];

            segments[s].base[0] <== m2e[s - 1].out[0];
            segments[s].base[1] <== m2e[s - 1].out[1];

            adders[s - 1] = BabyAdd();
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

    if (nsegments == 1) {
        out[0] <== segments[0].out[0];
        out[1] <== segments[0].out[1];
    } else {
        out[0] <== adders[nsegments - 2].xout;
        out[1] <== adders[nsegments - 2].yout;
    }
}
