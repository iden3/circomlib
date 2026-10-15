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
include "t1.circom";
include "t2.circom";
include "../binsum.circom";
include "sigmaplus.circom";
include "sha256compression_function.circom";
include "../buses.circom";


template Sha256compression() {
    BinaryNumber(256) input hin;
    BinaryNumber(512) input inp;
    BinaryNumber(256) output out;
    BinaryNumber(32) a[65];
    BinaryNumber(32) b[65];
    BinaryNumber(32) c[65];
    BinaryNumber(32) d[65];
    BinaryNumber(32) e[65];
    BinaryNumber(32) f[65];
    BinaryNumber(32) g[65];
    BinaryNumber(32) h[65];
    BinaryNumber(32) w[64];


    var outCalc[256] = sha256compression(hin.bits, inp.bits);

    var i;
    for (i=0; i<256; i++) out.bits[i] <-- outCalc[i];

    component sigmaPlus[48];
    for (i=0; i<48; i++) sigmaPlus[i] = SigmaPlus();

    component ct_k[64];
    for (i=0; i<64; i++) ct_k[i] = K(i);

    component t1[64];
    for (i=0; i<64; i++) t1[i] = T1();

    component t2[64];
    for (i=0; i<64; i++) t2[i] = T2();

    component suma[64];
    for (i=0; i<64; i++) suma[i] = BinSum(32, 2);

    component sume[64];
    for (i=0; i<64; i++) sume[i] = BinSum(32, 2);

    component fsum[8];
    for (i=0; i<8; i++) fsum[i] = BinSum(32, 2);

    var k;
    var t;

    for (t=0; t<64; t++) {
        if (t<16) {
            for (k=0; k<32; k++) {
                w[t].bits[k] <== inp.bits[t*32+31-k];
            }
        } else {
            sigmaPlus[t-16].in2 <== w[t-2];
            sigmaPlus[t-16].in7 <== w[t-7];
            sigmaPlus[t-16].in15 <== w[t-15];
            sigmaPlus[t-16].in16 <== w[t-16];

            w[t] <== sigmaPlus[t-16].out;
        }
    }

    for (k=0; k<32; k++ ) {
        a[0].bits[k] <== hin.bits[k];
        b[0].bits[k] <== hin.bits[32*1 + k];
        c[0].bits[k] <== hin.bits[32*2 + k];
        d[0].bits[k] <== hin.bits[32*3 + k];
        e[0].bits[k] <== hin.bits[32*4 + k];
        f[0].bits[k] <== hin.bits[32*5 + k];
        g[0].bits[k] <== hin.bits[32*6 + k];
        h[0].bits[k] <== hin.bits[32*7 + k];
    }

    for (t = 0; t<64; t++) {
        t1[t].h <== h[t];
        t1[t].e <== e[t];
        t1[t].f <== f[t];
        t1[t].g <== g[t];
        t1[t].k <== ct_k[t].out;
        t1[t].w <== w[t];

        t2[t].a <== a[t];
        t2[t].b <== b[t];
        t2[t].c <== c[t];

        sume[t].in[0] <== d[t];
        sume[t].in[1] <== t1[t].out;

        suma[t].in[0] <== t1[t].out;
        suma[t].in[1] <== t2[t].out;

        h[t+1] <== g[t];
        g[t+1] <== f[t];
        f[t+1] <== e[t];
        for (k=0; k<32; k++) {
            e[t+1].bits[k] <== sume[t].out.bits[k];
        }
        d[t+1] <== c[t];
        c[t+1] <== b[t];
        b[t+1] <== a[t];
        for (k=0; k<32; k++) {
            a[t+1].bits[k] <== suma[t].out.bits[k];
        }
    }

    fsum[0].in[1] <== a[64];
    fsum[1].in[1] <== b[64];
    fsum[2].in[1] <== c[64];
    fsum[3].in[1] <== d[64];
    fsum[4].in[1] <== e[64];
    fsum[5].in[1] <== f[64];
    fsum[6].in[1] <== g[64];
    fsum[7].in[1] <== h[64];

    for (k=0; k<32; k++) {
        fsum[0].in[0].bits[k] <==  hin.bits[32*0+k];
        fsum[1].in[0].bits[k] <==  hin.bits[32*1+k];
        fsum[2].in[0].bits[k] <==  hin.bits[32*2+k];
        fsum[3].in[0].bits[k] <==  hin.bits[32*3+k];
        fsum[4].in[0].bits[k] <==  hin.bits[32*4+k];
        fsum[5].in[0].bits[k] <==  hin.bits[32*5+k];
        fsum[6].in[0].bits[k] <==  hin.bits[32*6+k];
        fsum[7].in[0].bits[k] <==  hin.bits[32*7+k];
    }

    for (k=0; k<32; k++) {
        out.bits[31-k]     === fsum[0].out.bits[k];
        out.bits[32+31-k]  === fsum[1].out.bits[k];
        out.bits[64+31-k]  === fsum[2].out.bits[k];
        out.bits[96+31-k]  === fsum[3].out.bits[k];
        out.bits[128+31-k] === fsum[4].out.bits[k];
        out.bits[160+31-k] === fsum[5].out.bits[k];
        out.bits[192+31-k] === fsum[6].out.bits[k];
        out.bits[224+31-k] === fsum[7].out.bits[k];
    }
}
