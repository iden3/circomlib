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
include "bitify.circom";
include "comparators.circom";
include "mux1.circom";

template IntegerDivision(n) {
    // require max(a, b) < 2**n
    signal input a;
    signal input b;
    signal output c;
    assert (n < 253);
    assert (a < 2**n);
    assert (b < 2**n);

    var r = a;
    var d = b * 2**n;
    component b2n = Bits2Num(n);
    component lt[n];
    component mux[n];
    component mux1[n];

    for (var i = n - 1; i >= 0; i--) {
        lt[i] = LessThan(2*n);
        mux[i] = Mux1();
        mux1[i] = Mux1();
    }

    for (var i = n-1; i >= 0; i--) {
        lt[i].in[0] <== 2 * r; 
        lt[i].in[1] <== d;

        mux[i].s <== lt[i].out;
        mux[i].c[0] <== 1;
        mux[i].c[1] <== 0;

        mux1[i].s <== lt[i].out;
        mux1[i].c[0] <== 2 * r - d;
        mux1[i].c[1] <== 2 * r;

        b2n.in[i] <== mux[i].out;
        r =  mux1[i].out;
    }
    c <== b2n.out;
}

template ToFloat(W) {
    // W is the number of digits in decimal part
    assert (W <= 76); // 10^76 < 2^253
    signal input in;
    signal output out;
    assert (in < (10**(76-W)));
    out <== in * (10**W);
}

template DivisionFromFloat(W, n) {
    // W is the number of digits in decimal part
    // n is maximum width of a and b in binary form
    // assume a, b are both float representation
    signal input a;
    signal input b;
    signal output c;
    component div = IntegerDivision(n);
    div.a <== a * (10 ** W);
    div.b <== b;
    c <== div.c;
    log(c);
}

template DivisionFromNormal(W, n) {
    // W is the number of digits in decimal part
    // n is maximum width of integer part of a and b in binary form
    // assume a, b are both normal representation
    signal input a;
    signal input b;
    signal output c;
    component tfa = ToFloat(W);
    component tfb = ToFloat(W);
    component div = DivisionFromFloat(W, n);
    tfa.in <== a;
    tfb.in <== b;
    div.a <== tfa.out;
    div.b <== tfb.out;
    c <== div.c;
}

template MultiplicationFromFloat(W, n) {
    // W is the number of digits in decimal part
    // n is maximum width of integer part of a and b in binary form
    // assume a, b are both float representation
    signal input a;
    signal input b;
    signal output c;
    component div = IntegerDivision(n+4*W);
    div.a <== a * b;
    div.b <== 10**W;
    c <== div.c;
    log(c);
}

template MultiplicationFromNormal(W, n) {
    // W is the number of digits in decimal part
    // n is maximum width of integer part of a and b in binary form
    // assume a, b are both float representation
    signal input a;
    signal input b;
    signal output c;
    component tfa = ToFloat(W);
    component tfb = ToFloat(W);
    component mul = MultiplicationFromFloat(W, n);
    tfa.in <== a;
    tfb.in <== b;
    mul.a <== tfa.out;
    mul.b <== tfb.out;
    c <== mul.c;
}

