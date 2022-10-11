// DONE
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
include "matrixops.circom";
include "arrayops.circom";

/*
Used tags:
binary: is a tag without value that indicates that the signal should have a binary value (0 or 1);
        Formally: if x has tag binary then x*(x-1) === 0 is expected to be true
	(although it's not checked by the compiler)
*/

/*
    Window of 3 elements, it calculates
        out = base + base*in[0] + 2*base*in[1] + 4*base*in[2]
        out8 = 8*base

    The result should be compensated.
 */

template WindowMulFix() {
    signal input {binary} in[3];
    signal input base[2];
    signal output out[2];
    signal output out8[2];   // Returns 8*Base (To be linked)

// build this to select later 
//  [
//   [1*BASE[0],2*BASE[0],3*BASE[0],4*BASE[0],5*BASE[0],6*BASE[0],7*BASE[0],8*BASE[0]],
//   [1*BASE[0],2*BASE[0],3*BASE[0],4*BASE[0],5*BASE[0],6*BASE[0],7*BASE[0],8*BASE[0]]
//  ]

    signal tmuxc[8][2];
    tmuxc[0] <== base;
    tmuxc[1] <== MontgomeryDouble()(base);
    tmuxc[2] <== MontgomeryAdd()(base,tmuxc[1]);
    tmuxc[3] <== MontgomeryAdd()(base,tmuxc[2]);
    tmuxc[4] <== MontgomeryAdd()(base,tmuxc[3]);
    tmuxc[5] <== MontgomeryAdd()(base,tmuxc[4]);
    tmuxc[6] <== MontgomeryAdd()(base,tmuxc[5]);
    tmuxc[7] <== MontgomeryAdd()(base,tmuxc[6]);

    out8 <== tmuxc[7];
    out <== MultiMux3(2)(Transpose(8,2)(tmuxc),in);

}


/*
    This component does a multiplication of a escalar times a fix base
    Signals:
        e: The scalar in bits
        base: the base point in edwards format
        out:  The result
        dbl: Point in Edwards to be linked to the next segment.
 */

template SegmentMulFix(nWindows) {
    assert(nWindows > 0);
    
    var nw3 = nWindows*3;
    signal input  {binary} e[nw3];
    signal input base[2];
    signal output out[2];
    signal output dbl[2];

    var caddout[nWindows][2];
    var addout[nWindows][2];
    var wout8[nWindows][2];
    var wout[nWindows][2];
    
    // Convert the base to montgomery
    var e2mout[2] = Edwards2Montgomery()(base);

    if (nWindows == 1) {
        (wout[0],wout8[0]) = WindowMulFix()(ForceBinaryArray(3)(Slice(nw3,0,3)(e)),e2mout);
        // In the last step we add an extra doubler so that numbers do not match.
        var dblLast[2] = MontgomeryDouble()(wout8[0]);
	caddout[nWindows-1] = MontgomeryAdd()(e2mout,dblLast);
        addout[nWindows-1] = MontgomeryAdd()(dblLast,wout[0]);
    } else {
        (wout[0],wout8[0]) = WindowMulFix()(ForceBinaryArray(3)(Slice(nw3,0,3)(e)),e2mout);
	caddout[0] = MontgomeryAdd()(e2mout,wout8[0]);
        for (var i = 1; i < nWindows-1; i++) {
            (wout[i],wout8[i]) = WindowMulFix()(ForceBinaryArray(3)(Slice(nw3,3*i,3*i+3)(e)),wout8[i-1]);
	    caddout[i] = MontgomeryAdd()(caddout[i-1],wout8[i]);
        }
        (wout[nWindows-1],wout8[nWindows-1]) = WindowMulFix()(ForceBinaryArray(3)(Slice(nw3,nw3-3,nw3)(e)),wout8[nWindows-2]);
        // In the last step we add an extra doubler so that numbers do not match.
        var dblLast[2] = MontgomeryDouble()(wout8[nWindows-1]);
        caddout[nWindows-1] = MontgomeryAdd()(caddout[nWindows-2],dblLast);
	
        addout[0] = MontgomeryAdd()(dblLast,wout[0]);
        for (var i = 1; i < nWindows; i++) {
            addout[i] = MontgomeryAdd()(addout[i-1],wout[i]);
        }
    }

    var m2e_out[2] = Montgomery2Edwards()(addout[nWindows-1]);
    var cm2e_out[2] = Montgomery2Edwards()(caddout[nWindows-1]);

    BabyAdd()(m2e_out[0],m2e_out[1],-cm2e_out[0],cm2e_out[1]) ==> (out[0],out[1]);
    wout8[nWindows-1] ==> dbl;
}


/*
This component multiplies a escalar times a fixed point BASE (twisted edwards format)
    Signals
        e: The escalar in binary format
        out: The output point in twisted edwards
 */


/*  TODO REVISE THIS EXPLANATION!!!

    The scalar is s = a0 + a1*2^3 + a2*2^6 + ...... + a81*2^243
    First We calculate Q = B + 2^3*B + 2^6*B + ......... + 2^246*B

    Then we calculate S1 = 2*2^246*B + (1 + a0)*B + (2^3 + a1)*B + .....+ (2^243 + a81)*B

    And Finaly we compute the result: RES = SQ - Q

    As you can see the input of the adders cannot be equal nor zero, except for the last
    substraction that it's done in montgomery.

    A good way to see it is that the accumulator input of the adder >= 2^247*B and the other input
    is the output of the windows that it's going to be <= 2^246*B
 */
/*
template EscalarMulFix(n, BASE) {
    signal input {binary} e[n];     // Input in binary format
    signal output out[2];           // Point (Twisted format)

    var nsegments = (n-1)\246 +1;       // 249 probably would work. But I'm not sure and for security I keep 246
    var nlastsegment = n - (nsegments-1)*249;

    var segdbl[nsegments][2], segout[nsegments][2];
    var addxout[nsegments-1], addyout[nsegments-1];

    var nseg;
    var nWindows;

    for (var s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? 249 : nlastsegment;
        nWindows = ((nseg - 1)\3)+1;

         //var se[nWindows*3] = ForceBinaryArray(nWindows*3)(Concat(nseg,nWindows*3-nseg)(Slice(n,s*249,s*249+nseg)(e),Repeat(nWindows*3-nseg)(0)));

        if (s==0) {
	    (segdbl[s], segout[s]) = SegmentMulFix(nWindows)(ForceBinaryArray(nWindows*3)(Concat(nseg,nWindows*3-nseg)(Slice(n,s*249,s*249+nseg)(e),Repeat(nWindows*3-nseg)(0))),BASE);
	    //(segdbl[s], segout[s]) = SegmentMulFix(nWindows)(se,BASE);
        } else {
	    (segdbl[s], segout[s]) = SegmentMulFix(nWindows)(ForceBinaryArray(nWindows*3)(Concat(nseg,nWindows*3-nseg)(Slice(n,s*249,s*249+nseg)(e),Repeat(nWindows*3-nseg)(0))),Montgomery2Edwards()(segdbl[s-1]));
	    //(segdbl[s], segout[s]) = SegmentMulFix(nWindows)(se,Montgomery2Edwards()(segdbl[s-1]));
            if (s==1) {
	        (addxout[s-1],addyout[s-1]) = BabyAdd()(segout[s-1][0],segout[s-1][1],segout[s][0],segout[s][1]);
            } else {
	        (addxout[s-1],addyout[s-1]) = BabyAdd()(addxout[s-2],addyout[s-2],segout[s][0],segout[s][1]);
            }
        }
    }

    if (nsegments == 1) {
        segout[0] ==> out;
    } else {
        addxout[nsegments-2] ==> out[0];
        addyout[nsegments-2] ==> out[1];
    }
}
*/

template EscalarMulFix(n, BASE) {
    signal input {binary} e[n];              // Input in binary format
    signal output out[2];           // Point (Twisted format)

    var nsegments = (n-1)\246 +1;       // 249 probably would work. But I'm not sure and for security I keep 246
    var nlastsegment = n - (nsegments-1)*249;

    component segments[nsegments];

    component adders[nsegments-1];

    var s;
    var i;
    var nseg;
    var nWindows;

    for (s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? 249 : nlastsegment;
        nWindows = ((nseg - 1)\3)+1;

        segments[s] = SegmentMulFix(nWindows);

        //segments[s].e <== ForceBinaryArray(nWindows*3)(Concat(nseg,nWindows*3-nseg)(Slice(n,s*249,s*249+nseg)(e),Repeat(nWindows*3-nseg)(0)));


//comment
        for (i=0; i<nseg; i++) {
            segments[s].e[i] <== e[s*249+i];
        }

        for (i = nseg; i<nWindows*3; i++) {
            segments[s].e[i] <== 0;
        }
//end comment
	
        if (s==0) {
            segments[s].base <== BASE;
        } else {
            adders[s-1] = BabyAdd();

            Montgomery2Edwards()(segments[s-1].dbl) ==> segments[s].base;

            if (s==1) {
                segments[s-1].out[0] ==> adders[s-1].x1;
                segments[s-1].out[1] ==> adders[s-1].y1;
            } else {
                adders[s-2].xout ==> adders[s-1].x1;
                adders[s-2].yout ==> adders[s-1].y1;
            }
            segments[s].out[0] ==> adders[s-1].x2;
            segments[s].out[1] ==> adders[s-1].y2;
        }
    }

    if (nsegments == 1) {
        segments[0].out ==> out;
    } else {
        adders[nsegments-2].xout ==> out[0];
        adders[nsegments-2].yout ==> out[1];
    }
}
