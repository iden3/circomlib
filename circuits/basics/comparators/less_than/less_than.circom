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

include "../../bitify/num2bits/num2bits.circom";

template LessThan(n) {
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n*2+1);

    n2b.in <== in[0] + (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

/*
// `n` is the number of bits the input has.
// The MSF is the sign bit.
template LessThan(n) {
    signal input in[2];
    signal output out;

    component num2Bits0;
    component num2Bits1;

    component adder;

    adder = BinSum(n, 2);

    num2Bits0 = Num2Bits(n);
    num2Bits1 = Num2BitsNeg(n);

    in[0] ==> num2Bits0.in;
    in[1] ==> num2Bits1.in;

    var i;
    for (i=0;i<n;i++) {
        num2Bits0.out[i] ==> adder.in[0][i];
        num2Bits1.out[i] ==> adder.in[1][i];
    }

    adder.out[n-1] ==> out;
}
*/