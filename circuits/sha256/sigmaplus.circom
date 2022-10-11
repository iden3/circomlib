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

template SigmaPlus() {
    signal input {binary} in2[32];
    signal input {binary} in7[32];
    signal input {binary} in15[32];
    signal input {binary} in16[32];
    signal output {binary} out[32];
    signal {binary} sumin [4][32];
  
    sumin[0] <== SmallSigma(17,19,10)(in2);
    sumin[1] <== in7;
    sumin[2] <== SmallSigma(7, 18, 3)(in15);
    sumin[3] <== in16;

    signal {binary} sumout[34] <== BinSum(32, 4)(sumin);

    for (var k=0; k<32; k++) {
        out[k] <== sumout[k];
    }
}
