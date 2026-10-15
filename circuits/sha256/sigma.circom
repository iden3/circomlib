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

include "xor3.circom";
include "rotate.circom";
include "shift.circom";
include "../buses.circom";

template SmallSigma(ra, rb, rc) {
    BinaryNumber(32) input in;
    BinaryNumber(32) output out;

    component rota = RotR(32, ra);
    component rotb = RotR(32, rb);
    component shrc = ShR(32, rc);

    rota.in <== in;
    rotb.in <== in;
    shrc.in <== in;

    component xor3 = Xor3(32);
    xor3.a <== rota.out;
    xor3.b <== rotb.out;
    xor3.c <== shrc.out;

    out <== xor3.out;
}

template BigSigma(ra, rb, rc) {
    BinaryNumber(32) input in;
    BinaryNumber(32) output out;

    component rota = RotR(32, ra);
    component rotb = RotR(32, rb);
    component rotc = RotR(32, rc);
    rota.in <== in;
    rotb.in <== in;
    rotc.in <== in;

    component xor3 = Xor3(32);

    xor3.a <== rota.out;
    xor3.b <== rotb.out;
    xor3.c <== rotc.out;

    out <== xor3.out;
}
