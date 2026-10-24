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

include "constants.circom";
include "sha256compression.circom";
include "../bitify.circom";
include "../binnum.circom";

template Sha256_2() {
    input signal a;
    input signal b;
    output signal {maxbit} out;

    var i;
    var k;

    component bits2num = Bits2Num(216);
    component num2bits[2];

    num2bits[0] = Num2Bin(216);
    num2bits[1] = Num2Bin(216);

    num2bits[0].in <== a;
    num2bits[1].in <== b;


    component sha256compression = Sha256compression() ;

    component ha0 = H(0);
    component hb0 = H(1);
    component hc0 = H(2);
    component hd0 = H(3);
    component he0 = H(4);
    component hf0 = H(5);
    component hg0 = H(6);
    component hh0 = H(7);

    for (k=0; k<32; k++ ) {
        sha256compression.hin.bits[0*32+k] <== ha0.out.bits[k];
        sha256compression.hin.bits[1*32+k] <== hb0.out.bits[k];
        sha256compression.hin.bits[2*32+k] <== hc0.out.bits[k];
        sha256compression.hin.bits[3*32+k] <== hd0.out.bits[k];
        sha256compression.hin.bits[4*32+k] <== he0.out.bits[k];
        sha256compression.hin.bits[5*32+k] <== hf0.out.bits[k];
        sha256compression.hin.bits[6*32+k] <== hg0.out.bits[k];
        sha256compression.hin.bits[7*32+k] <== hh0.out.bits[k];
    }

    for (i=0; i<216; i++) {
        sha256compression.inp.bits[i] <== num2bits[0].out.bits[215-i];
        sha256compression.inp.bits[i+216] <== num2bits[1].out.bits[215-i];
    }

    signal {binary} aux1 <== 1;
    signal {binary} aux0 <== 0;

    sha256compression.inp.bits[432] <== aux1;

    for (i=433; i<503; i++) {
        sha256compression.inp.bits[i] <== aux0;
    }

    sha256compression.inp.bits[503] <== aux1;
    sha256compression.inp.bits[504] <== aux1;
    sha256compression.inp.bits[505] <== aux0;
    sha256compression.inp.bits[506] <== aux1;
    sha256compression.inp.bits[507] <== aux1;
    sha256compression.inp.bits[508] <== aux0;
    sha256compression.inp.bits[509] <== aux0;
    sha256compression.inp.bits[510] <== aux0;
    sha256compression.inp.bits[511] <== aux0;

    for (i=0; i<216; i++) {
        bits2num.in[i] <== sha256compression.out.bits[255-i];
    }

    out <== bits2num.out;
}
