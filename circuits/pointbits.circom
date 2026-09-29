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
include "buses.circom";

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

*** Bits2Point_Strict(): template that receives the encoding of a point of a curve and returns its Edwards representation
        - Inputs: in -> BinaryPoint(254) bus encoding the point in 255 bits
                        requires tag binary on both fields
        - Outputs: pout -> curve point using Edwards representation
                           satisfies tag babyedwards
                               
    Encoding:
       in.binY[0..253] -> binary representation of pout.y
       in.signX -> if pout.x is positive then 0, else 1

    The encoding of a point on the wire is usually 256 bits, of which bit 254 is always 0
    and bit 255 carries the sign. A BinaryPoint has no bit 254, so code that converts such
    an encoding into the bus must check that bit itself and reject a non-zero one. Two
    encodings otherwise map to the same point. See test/circuits/eddsapedersen_test.circom.
*/


template Bits2Point_Strict() {
    BinaryPoint(254) input in;
    output Point {babyedwards} pout;

    var i;

    // Check aliasing
    component aliasCheckY = AliasCheck();
    aliasCheckY.in <== in.binY;

    component b2nY = Bits2Num(254);
    b2nY.in <== in.binY;

    pout.y <== b2nY.out;

    var a = 168700;
    var d = 168696;

    var y2 = pout.y * pout.y;

    var x = sqrt(   (1-y2)/(a - d*y2)  );

    if (in.signX == 1) x = -x;

    pout.x <-- x;

    component babyCheck = BabyCheck();
    babyCheck.pin <== pout;

    component n2bX = Num2Bits(254);
    n2bX.in <== pout.x;
    component aliasCheckX = AliasCheck();
    aliasCheckX.in <== n2bX.out;

    component signCalc = CompConstant(maxbits(), 10944121435919637611123202872628637544274182200208017171849102093287904247808);
    signCalc.in <== n2bX.out;

    signCalc.out === in.signX;
}


/*

*** Point2Bits_Strict(): template that receives a point of the curve as an input and returns its encoding
        - Inputs: pin -> curve point using Edwards representation
                         requires tag babyedwards
        - Outputs: out -> BinaryPoint(254) bus encoding the point in 255 bits
                          both fields satisfy tag binary
                               
    Encoding:
       out.binY[0..253] -> binary representation of pin.y
       out.signX -> if pin.x is positive then 0, else 1

    To widen this to the usual 256 bit encoding, bit 254 is 0 and bit 255 is out.signX.
*/

template Point2Bits_Strict() {
    input Point {babyedwards} pin;
    BinaryPoint(254) output out;

    var i;

    component n2bX = Num2Bits(254);
    n2bX.in <== pin.x;
    component n2bY = Num2Bits(254);
    n2bY.in <== pin.y;

    component aliasCheckX = AliasCheck();
    component aliasCheckY = AliasCheck();
    aliasCheckX.in <== n2bX.out;
    aliasCheckY.in <== n2bY.out;

    component signCalc = CompConstant(maxbits(), 10944121435919637611123202872628637544274182200208017171849102093287904247808);
    signCalc.in <== n2bX.out;

    out.binY <== n2bY.out;
    out.signX <== signCalc.out;
}
