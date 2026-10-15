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

include "../binsum.circom";
include "sigma.circom";
include "../buses.circom";

template SigmaPlus() {
    BinaryNumber(32) input in2;
    BinaryNumber(32) input in7;
    BinaryNumber(32) input in15;
    BinaryNumber(32) input in16;
    BinaryNumber(32) output out;
    var k;

    component sigma1 = SmallSigma(17,19,10);
    component sigma0 = SmallSigma(7, 18, 3);
    sigma1.in <== in2;
    sigma0.in <== in15;

    component sum = BinSum(32, 4);
    sum.in[0] <== sigma1.out;
    sum.in[1] <== in7;
    sum.in[2] <== sigma0.out;
    sum.in[3] <== in16;

    // BinSum(32,4) returns 34 bits: keep the 32 least significant ones
    // (addition modulo 2**32, as SHA-256 requires)
    for (k=0; k<32; k++) {
        out.bits[k] <== sum.out.bits[k];
    }
}
