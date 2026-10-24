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
include "maj.circom";
include "../../buses.circom";

template T2() {
    BinaryNumber(32) input a;
    BinaryNumber(32) input b;
    BinaryNumber(32) input c;
    BinaryNumber(32) output out;
    var k;

    component bigsigma0 = BigSigma(2, 13, 22);
    component maj = Maj_t(32);
    bigsigma0.in <== a;
    maj.a <== a;
    maj.b <== b;
    maj.c <== c;

    component sum = BinSum(32, 2);

    sum.in[0] <== bigsigma0.out;
    sum.in[1] <== maj.out;
    // BinSum(32,2) returns 33 bits: keep the 32 least significant ones
    // (addition modulo 2**32)
    for (k=0; k<32; k++) {
        out.bits[k] <== sum.out.bits[k];
    }

}
