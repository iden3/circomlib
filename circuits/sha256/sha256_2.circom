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

template Sha256_2() {
    signal input a;
    signal input b;
    signal output out;

    var i;
    var k;

    component num2bits[2];

    num2bits[0] = Num2Bits(216);
    num2bits[1] = Num2Bits(216);

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

    signal {binary} auxhin[256];
    for (k=0; k<32; k++ ) {
        auxhin[0*32+k] <== ha0.out[k];
        auxhin[1*32+k] <== hb0.out[k];
        auxhin[2*32+k] <== hc0.out[k];
        auxhin[3*32+k] <== hd0.out[k];
        auxhin[4*32+k] <== he0.out[k];
        auxhin[5*32+k] <== hf0.out[k];
        auxhin[6*32+k] <== hg0.out[k];
        auxhin[7*32+k] <== hh0.out[k];
    }

    sha256compression.hin <== auxhin;

    signal {binary} auxinp[512];
    
    for (i=0; i<216; i++) {
        auxinp[i] <== num2bits[0].out[215-i];
        auxinp[i+216] <== num2bits[1].out[215-i];
    }

    auxinp[432] <== 1;

    for (i=433; i<503; i++) {
        auxinp[i] <== 0;
    }

    auxinp[503] <== 1;
    auxinp[504] <== 1;
    auxinp[505] <== 0;
    auxinp[506] <== 1;
    auxinp[507] <== 1;
    auxinp[508] <== 0;
    auxinp[509] <== 0;
    auxinp[510] <== 0;
    auxinp[511] <== 0;

    sha256compression.inp <== auxinp;
    
    component bits2num = Bits2Num(216);
    for (i=0; i<216; i++) {
        bits2num.in[i] <== sha256compression.out[255-i];
    }

    out <== bits2num.out;
}
