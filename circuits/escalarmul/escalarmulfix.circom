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

include "../mux3.circom";
include "../montgomery.circom";
include "../babyjub.circom";
include "../buses.circom";


// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617.

/*
    Fixed-base scalar multiplication on Baby Jubjub: pout = (sum_i e[i]*2^i) * BASE.

    The scalar is processed in 3-bit windows, using the cheap but incomplete
    Montgomery formulas (see montgomery.circom). The windows are arranged so
    that those formulas never meet an exceptional case.
*/
 
 
/*
    One 3-bit window, in Montgomery form. With v = in[0] + 2*in[1] + 4*in[2]:
        pout  = (1 + v) * base     (never the identity)
        pout8 = 8 * base           (it is the next window's base)
    The table (1..8)*base is built with one double and six adds, and MultiMux3
    selects from it.
*/
 
template WindowMulFix() {
    input signal {binary} in[3];
    input Point {base, min_scalar, max_scalar, babymontgomery} base;
    output Point {base, min_scalar, max_scalar, babymontgomery} pout;
    output Point {base, min_scalar, max_scalar, babymontgomery} pout8;   // Returns 8*Base (To be linked)

    component mux = MultiMux3(2);

    mux.s[0] <== in[0];
    mux.s[1] <== in[1];
    mux.s[2] <== in[2];

    component dbl2 = MontgomeryDouble();
    component adr3 = MontgomeryAdd();
    component adr4 = MontgomeryAdd();
    component adr5 = MontgomeryAdd();
    component adr6 = MontgomeryAdd();
    component adr7 = MontgomeryAdd();
    component adr8 = MontgomeryAdd();

// in[0]  -> 1*BASE

    mux.c[0][0] <== base.x;
    mux.c[1][0] <== base.y;

// in[1] -> 2*BASE
    dbl2.pin <== base;
    mux.c[0][1] <== dbl2.pout.x;
    mux.c[1][1] <== dbl2.pout.y;

// in[2] -> 3*BASE
    adr3.pin1 <== base;
    adr3.pin2 <== dbl2.pout;
    mux.c[0][2] <== adr3.pout.x;
    mux.c[1][2] <== adr3.pout.y;

// in[3] -> 4*BASE
    adr4.pin1 <== base;
    adr4.pin2 <== adr3.pout;
    mux.c[0][3] <== adr4.pout.x;
    mux.c[1][3] <== adr4.pout.y;

// in[4] -> 5*BASE
    adr5.pin1 <== base;
    adr5.pin2 <== adr4.pout;
    mux.c[0][4] <== adr5.pout.x;
    mux.c[1][4] <== adr5.pout.y;

// in[5] -> 6*BASE
    adr6.pin1 <== base;
    adr6.pin2 <== adr5.pout;
    mux.c[0][5] <== adr6.pout.x;
    mux.c[1][5] <== adr6.pout.y;

// in[6] -> 7*BASE
    adr7.pin1 <== base;
    adr7.pin2 <== adr6.pout;
    mux.c[0][6] <== adr7.pout.x;
    mux.c[1][6] <== adr7.pout.y;

// in[7] -> 8*BASE
    adr8.pin1 <== base;
    adr8.pin2 <== adr7.pout;
    mux.c[0][7] <== adr8.pout.x;
    mux.c[1][7] <== adr8.pout.y;

    pout8 <== adr8.pout;

    pout.x <== mux.out[0];
    pout.y <== mux.out[1];
    pout.base = base.base;
    pout.min_scalar = base.min_scalar;
    pout.max_scalar = base.max_scalar*8;
}


/*
    pout = s * base, where s = sum_i v_i * 8^i and v_i is window i.
    base and pout are in Edwards form. dbl = 8^nWindows * base is in Montgomery
    form and is linked to the next segment.

    Each window contributes (1 + v_i) * 8^i * base, so the sum carries an extra
    C = sum_i 8^i * base. To keep the Montgomery additions safe, the accumulator
    also starts at D = 2 * 8^nWindows * base. Then:
        adders:  D + sum_i (1 + v_i) * 8^i * base  = D + C + s*base
        cadders: C + D                                  (compensation)
        pout   = (D + C + s*base) - (C + D)  = s*base   (complete BabyAdd)

    Safety: the accumulator is always >= D = 2*8^nWindows, and each window output
    is <= 8^nWindows, so the two inputs of an add are never equal. They are also
    never opposite (acc + w != 0 mod l) as long as acc + w < l, which holds for
    nWindows <= 82 (246 bits) but not for 83. EscalarMulFix guarantees this bound.
*/

template SegmentMulFix(nWindows,Id) {
    input signal {binary} e[nWindows*3];
    input Point {nonzerox, babyedwards} base;
    output Point {babyedwards} pout;
    output Point {base, min_scalar, max_scalar, babymontgomery} dbl;

    var i;
    var j;

    // Convert the base to montgomery

    component e2m = Edwards2Montgomery(Id);
    e2m.pin <== base;

    component windows[nWindows];
    component adders[nWindows];
    component cadders[nWindows];

    // D = 2 * 8^nWindows * base
    component dblLast = MontgomeryDouble();

    // Windows and compensation chain: cadders = base + 8*base + ... + 8^(nWindows-1)*base + D

    for (i=0; i<nWindows; i++) {
        windows[i] = WindowMulFix();
        cadders[i] = MontgomeryAdd();
        if (i==0) {
            windows[i].base <== e2m.pout;
            cadders[i].pin1 <== e2m.pout;
        } else {
            windows[i].base <== windows[i-1].pout8;
            cadders[i].pin1 <== cadders[i-1].pout;
        }
        for (j=0; j<3; j++) {
            windows[i].in[j] <== e[3*i+j];
        }
        if (i<nWindows-1) {
            cadders[i].pin2 <== windows[i].pout8;
        } else {
            dblLast.pin <== windows[i].pout8;
            cadders[i].pin2 <== dblLast.pout;
        }
    }

    // Accumulator chain: D + sum of window outputs
    for (i=0; i<nWindows; i++) {
        adders[i] = MontgomeryAdd();
        if (i==0) {
            adders[i].pin1 <== dblLast.pout;
        } else {
            adders[i].pin1 <== adders[i-1].pout;
        }
        adders[i].pin2 <== windows[i].pout;
    }

    component m2e = Montgomery2Edwards();
    component cm2e = Montgomery2Edwards();

    m2e.pin <== adders[nWindows-1].pout;
    cm2e.pin <== cadders[nWindows-1].pout;

    // pout = acc - compensation
    component cAdd = BabyAdd();
    cAdd.pin1 <== m2e.pout;
    
    Point {babyedwards} aux;
    aux.x <== -cm2e.pout.x;
    aux.y <== cm2e.pout.y;
    cAdd.pin2 <== aux;

    cAdd.pout ==> pout;

    windows[nWindows-1].pout8 ==> dbl;
}


/*
    pout = (sum_i e[i]*2^i) * BASE, with BASE a constant point in Edwards form.

    The scalar is split into segments of 246 bits (82 windows), within the
    safety bound of SegmentMulFix. Segment s uses base 2^(246*s) * BASE,
    obtained from the previous segment's dbl, and the segment results are
    summed with BabyAdd, which is complete.
*/
 
 
template EscalarMulFix(n, BASE) {
    input signal {binary} e[n];              // Input in binary format
    output Point {babyedwards} pout;           // Point (Twisted format)

    var segmentSize = 246;
    var nsegments = (n-1)\segmentSize +1;
    var nlastsegment = n - (nsegments-1)*segmentSize;

    component segments[nsegments];

    component m2e[nsegments-1];
    component adders[nsegments-1];
    
    Point {babyedwards} aux_base;
    aux_base.x <== BASE[0];
    aux_base.y <== BASE[1];

    var s;
    var i;
    var nseg;
    var nWindows;
    
    signal {binary} aux_0 <== 0;

    for (s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? segmentSize : nlastsegment;
        nWindows = ((nseg - 1)\3)+1;

        segments[s] = SegmentMulFix(nWindows,s);

        for (i=0; i<nseg; i++) {
            segments[s].e[i] <== e[s*segmentSize+i];
        }

        for (i = nseg; i<nWindows*3; i++) {
            segments[s].e[i] <== aux_0;   // padding
        }

        if (s==0) {
            segments[s].base <== NonZeroXCheck()(aux_base);
        } else {
            m2e[s-1] = Montgomery2Edwards();
            adders[s-1] = BabyAdd();

            segments[s-1].dbl ==> m2e[s-1].pin;

            m2e[s-1].pout ==> segments[s].base;

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
