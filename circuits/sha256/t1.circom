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
include "ch.circom";
include "../buses.circom";

template T1() {
    BinaryNumber(32) input h;
    BinaryNumber(32) input e;
    BinaryNumber(32) input f;
    BinaryNumber(32) input g;
    BinaryNumber(32) input k;
    BinaryNumber(32) input w;
    BinaryNumber(32) output out;

    var ki;

    component ch = Ch_t(32);
    component bigsigma1 = BigSigma(6, 11, 25);

    bigsigma1.in <== e;
    ch.a <== e;
    ch.b <== f;
    ch.c <== g;

    component sum = BinSum(32, 5);
    sum.in[0] <== h;
    sum.in[1] <== bigsigma1.out;
    sum.in[2] <== ch.out;
    sum.in[3] <== k;
    sum.in[4] <== w;
    // BinSum(32,5) returns 35 bits: keep the 32 least significant ones
    // (addition modulo 2**32)
    for (ki=0; ki<32; ki++) {
        out.bits[ki] <== sum.out.bits[ki];
    }

}
