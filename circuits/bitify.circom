//DONE
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

include "comparators.circom";
include "aliascheck.circom";

/*
Used tags:
binary: is a tag without value that indicates that the signal should have a binary value (0 or 1);
        Formally: if x has tag binary then x*(x-1) === 0 is expected to be true
	(although it's not checked by the compiler)

maxbit: is a tag with value that indicates maximum number of bits needed to represent the signal value;
        Formally: if x has tag maxbit with value m then there should exist x_0...x_{m-1} with x_i*(x_i-1) === 0 s.t.
        x = sum_{i=0}^{n-1} x_i * 2**i (although it's not checked by the compiler)

In all these templates if the inputs fulfil the conditions associated to their tags then
the outputs fulfil the conditions associated to their tags
*/

function NeededBits (n) {
    if (n == 0) return 1;
    var b = 0, res = n;
    while (res != 0) {
        res >>= 1;
	b++;
    }
    return b;
}
	
template Num2Bits(n) {
    signal input in;
    signal output {binary} out[n];

    var lc1=0;
    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template Num2Bits_strict() {
    signal input in;
    signal output {binary} out[254];
    
    Num2Bits(254)(in) ==> out;
    AliasCheck()(out);  //TODO check No need!
}

template Bits2Num(n) {
    signal input {binary} in[n];
    signal output {maxbit} out;
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i<n; i++) {
        lc1 += in[i] * e2;
        e2 = e2 + e2;
    }

    out.maxbit = n;
    lc1 ==> out;
}

template Bits2Num_strict() {
    signal input {binary} in[254];
    signal output {maxbit} out;

    AliasCheck()(in);
    Bits2Num(254)(in) ==> out;
}

template Num2BitsNeg(n) {
    signal input in;
    signal output {binary} out[n];
    var lc1=0;

    var neg = n == 0 ? 0 : 2**n - in;

    for (var i = 0; i<n; i++) {
        out[i] <-- (neg >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * 2**i;
    }

    var iszero = IsZero()(in);
    lc1 + iszero * 2**n === 2**n - in;
}

template AddBinaryTag () {
    signal input in;
    signal output {binary} out;

    in * (in - 1) === 0;
    out <== in;
}

template AddBinaryArrayTag(n) {
    signal input in[n];
    signal output {binary} out[n];

    for (var i = 0; i < n; i++) {
       in[i] * (in[i] - 1) === 0;
    }
    out <== in;
}

template ForceBinaryArray(n) {
    signal input in[n];
    signal output {binary} out[n];

    out <== in;
}

template ForceBinary() {
    signal input in;
    signal output {binary} out;

    out <== in;
}

template ForceBinaryMatrix(n,m) {
    signal input in[n][m];
    signal output {binary} out[n][m];

    out <== in;
}

template AddBinaryCheck () {
    signal input in;

    in * (in - 1) === 0;
}

template AddMaxbitTag(n) {
    signal input in;
    signal output {maxbit} out;

    out.maxbit = n;
    _ <== Num2Bits(n)(in);
    in ==> out;
}

template AddMaxbitArrayTag(n,m) {
    signal input in[m];
    signal output {maxbit} out[m];

    out.maxbit = n;

    for (var i = 0; i < m; i++) {
       _ <== Num2Bits(n)(in[i]);
    }
    
    in ==> out;
}
