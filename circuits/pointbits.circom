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

// The templates and functions of this file only work for prime field bn128 (21888242871839275222246405745257275088548364400416034343698204186575808495617)

include "bitify.circom";
include "aliascheck.circom";
include "comparators.circom";
include "babyjub.circom";


/*

*** sqrt(n): function that returns the square of the value n. 
    That is, it returns a value r s.t. r * r = n mod p
    
 */

function sqrt(n) {

    if (n == 0) {
        return 0;
    }

    // Test that have solution
    var res = n ** ((-1) >> 1);
//        if (res!=1) assert(false, "SQRT does not exists");
    if (res!=1) return 0;

    var m = 28;
    var c = 19103219067921713944291392827692070036145651957329286315305642004821462161904;
    var t = n ** 81540058820840996586704275553141814055101440848469862132140264610111;
    var r = n ** ((81540058820840996586704275553141814055101440848469862132140264610111+1)>>1);
    var sq;
    var i;
    var b;
    var j;

    while ((r != 0)&&(t != 1)) {
        sq = t*t;
        i = 1;
        while (sq!=1) {
            i++;
            sq = sq*sq;
        }

        // b = c ^ m-i-1
        b = c;
        for (j=0; j< m-i-1; j ++) b = b*b;

        m = i;
        c = b*b;
        t = t*c;
        r = r*b;
    }

    if (r < 0 ) {
        r = -r;
    }

    return r;
}

/*

*** Bits2Point_Strict(): template that receives the encoding of a point of a curve using 256 bits and returns its Edwards representation
        - Inputs: in[256] -> encoding of the point using 256 bits 
                             requires tag binary
        - Outputs: out[2] -> curve point using Edwards representation
                               
    Encoding:
       in[0..253] -> binary representation of out[1]
       in[254] -> 0
       in[255] -> if out[0] is positive then 0, else 1
*/


template Bits2Point_Strict() {
    signal input {binary} in[256];
    signal output out[2];

    var i;

    // Check aliasing
    component aliasCheckY = AliasCheck();
    for (i=0; i<254; i++) {
        aliasCheckY.in[i] <== in[i];
    }
    in[254] === 0;

    component b2nY = Bits2Num(254);
    for (i=0; i<254; i++) {
        b2nY.in[i] <== in[i];
    }

    out[1] <== b2nY.out;

    var a = 168700;
    var d = 168696;

    var y2 = out[1] * out[1];

    var x = sqrt(   (1-y2)/(a - d*y2)  );

    if (in[255] == 1) x = -x;

    out[0] <-- x;

    component babyCheck = BabyCheck();
    babyCheck.x <== out[0];
    babyCheck.y <== out[1];

    component n2bX = Num2Bits(254);
    n2bX.in <== out[0];
    component aliasCheckX = AliasCheck();
    for (i=0; i<254; i++) {
        aliasCheckX.in[i] <== n2bX.out[i];
    }

    component signCalc = CompConstant(10944121435919637611123202872628637544274182200208017171849102093287904247808);
    for (i=0; i<254; i++) {
        signCalc.in[i] <== n2bX.out[i];
    }

    signCalc.out === in[255];
}


/*

*** Point2Bits_Strict(): template that receives a point as an input and returns its encoding using 256 bits
        - Inputs: in[2] -> curve point using Edwards representation
        - Outputs: out[256] -> encoding of the point using 256 bits
                               satisfies tag binary
                               
    Encoding:
       out[0..253] -> binary representation of in[1]
       out[254] -> 0
       out[255] -> if in[0] is positive then 0, else 1
*/

template Point2Bits_Strict() {
    signal input in[2];
    signal output {binary} out[256];

    var i;

    component n2bX = Num2Bits(254);
    n2bX.in <== in[0];
    component n2bY = Num2Bits(254);
    n2bY.in <== in[1];

    component aliasCheckX = AliasCheck();
    component aliasCheckY = AliasCheck();
    for (i=0; i<254; i++) {
        aliasCheckX.in[i] <== n2bX.out[i];
        aliasCheckY.in[i] <== n2bY.out[i];
    }

    component signCalc = CompConstant(10944121435919637611123202872628637544274182200208017171849102093287904247808);
    for (i=0; i<254; i++) {
        signCalc.in[i] <== n2bX.out[i];
    }

    for (i=0; i<254; i++) {
        out[i] <== n2bY.out[i];
    }
    out[254] <== 0;
    out[255] <== signCalc.out;
}
