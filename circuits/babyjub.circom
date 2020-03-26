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

include "bitify.circom";
include "escalarmulfix.circom";
include "comparators.circom";

function inCurve(P) {
    var A = 168700;
    var D = 168696;
    var x2 = P[0]*P[0];
    var y2 = P[1]*P[1];
    if ((A * x2 + y2) == ( 1 + D*x2*y2)){
        return 1;
    } else {
        return 0;
    }
    return 0;
}


template InCurve() {
    signal input in[2];
    signal output out;
    var A = 168700;
    var D = 168696;

    signal x2;
    x2 <== in[0] * in[0];
    signal y2;
    y2 <== in[1] * in[1];

    component res = IsZero();
    res.in <== A * x2 + y2 - 1 - D * x2 * y2;
    out <== res.out;
}


function babyAdd(a,b) {
    var A = 168700;
    var D = 168696;
    return [(a[0]*b[1]+b[0]*a[1])/(1 + D*a[0]*b[0]*a[1]*b[1]), (a[1]*b[1] - A*a[0]*b[0])/(1 - D*a[0]*b[0]*a[1]*b[1])];

}

function mulPointEscalar(base, e) {
    var res = [0, 1];
    var rem = e;
    var exp = base;

    while (rem!=0) {
        if (rem&1==1) {
            res = babyAdd(res, exp);
        }
        exp = babyAdd(exp, exp);
        rem = rem >> 1;
    }

    return res;
}

function babyNeg(p) {
    return [-p[0], p[1]];
}


template BabyAdd() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal output xout;
    signal output yout;

    signal beta;
    signal gamma;
    signal delta;
    signal tau;

    var a = 168700;
    var d = 168696;

    beta <== x1*y2;
    gamma <== y1*x2;
    delta <== (-a*x1+y1)*(x2 + y2);
    tau <== beta * gamma;

    xout <-- (beta + gamma) / (1+ d*tau);
    (1+ d*tau) * xout === (beta + gamma);

    yout <-- (delta + a*beta - gamma) / (1-d*tau);
    (1-d*tau)*yout === (delta + a*beta - gamma);
}

template BabyDbl() {
    signal input x;
    signal input y;
    signal output xout;
    signal output yout;

    component adder = BabyAdd();
    adder.x1 <== x;
    adder.y1 <== y;
    adder.x2 <== x;
    adder.y2 <== y;

    adder.xout ==> xout;
    adder.yout ==> yout;
}

template BabyMul8() {
    signal input x;
    signal input y;
    signal output xout;
    signal output yout;

    component dbl1 = BabyDbl();
    dbl1.x <== x;
    dbl1.y <== y;
    component dbl2 = BabyDbl();
    dbl2.x <== dbl1.xout;
    dbl2.y <== dbl1.yout;
    component dbl3 = BabyDbl();
    dbl3.x  <== dbl2.xout;
    dbl3.y  <== dbl2.yout;
    xout <== dbl3.xout;
    yout <== dbl3.yout;
}

template BabyIsZero() {
    signal input x;
    signal input y;
    signal output out;
    component xz = IsZero();
    xz.in <== x;
    component yz = IsZero();
    yz.in <== y-1;
    out <== xz.out * yz.out;

}

template BabyCheck() {
    signal input x;
    signal input y;

    signal x2;
    signal y2;

    var a = 168700;
    var d = 168696;

    x2 <== x*x;
    y2 <== y*y;

    a*x2 + y2 === 1 + d*x2*y2;
}

// Extracts the public key from private key
template BabyPbk() {
    signal private input  in;
    signal         output Ax;
    signal         output Ay;

    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    component pvkBits = Num2Bits(253);
    pvkBits.in <== in;

    component mulFix = EscalarMulFix(253, BASE8);

    var i;
    for (i=0; i<253; i++) {
        mulFix.e[i] <== pvkBits.out[i];
    }
    Ax  <== mulFix.out[0];
    Ay  <== mulFix.out[1];
}
