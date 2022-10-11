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

template T1() {
    signal input {binary} h[32];
    signal input {binary} e[32];
    signal input {binary} f[32];
    signal input {binary} g[32];
    signal input {binary} k[32];
    signal input {binary} w[32];
    signal output {binary} out[32];

    component sum = BinSum(32, 5);
    
    sum.in[0] <== h;
    sum.in[1] <== BigSigma(6, 11, 25)(e);
    sum.in[2] <== Ch_t(32)(e,f,g);
    sum.in[3] <== k;
    sum.in[4] <== w;

    for (var ki=0; ki<32; ki++) {
        out[ki] <== sum.out[ki];
    }
}
