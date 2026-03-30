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
pragma circom 2.1.5;

include "xor3.circom";
include "rotate.circom";
include "shift.circom";


/*

*** SmallSigma(ra, rb, rc): template that receives an array in of 32 bits and returns an array out of 32 bits s.t. out[i] = XOR3(rot_a[i], rot_b[i], shift_c[i]) with
     * rot_a is the array in rotated ra bits to the right (see rotate.circom)
     * rot_b is the array in rotated rb bits to the right (see rotate.circom)
     * shift_c is the array in shifted rc bits to the right (see shift.circom)
        - Inputs: in[n] -> array of n bits
                          requires tag binary
        - Output: out[n] -> array of n bits, it takes the value described above
                            satisfies tag binary

*/

template SmallSigma(ra, rb, rc) {
    signal input {binary} in[32];
    signal output {binary} out[32];
    var k;

    component rota = RotR(32, ra);
    component rotb = RotR(32, rb);
    component shrc = ShR(32, rc);

    for (k=0; k<32; k++) {
        rota.in[k] <== in[k];
        rotb.in[k] <== in[k];
        shrc.in[k] <== in[k];
    }

    component xor3 = Xor3(32);
    for (k=0; k<32; k++) {
        xor3.a[k] <== rota.out[k];
        xor3.b[k] <== rotb.out[k];
        xor3.c[k] <== shrc.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor3.out[k];
    }
}

/*

*** BigSigma(ra, rb, rc): template that receives an array in of 32 bits and returns an array out of 32 bits s.t. out[i] = XOR3(rot_a[i], rot_b[i], rot_c[i]) with
     * rot_a is the array in rotated ra bits to the right (see rotate.circom)
     * rot_b is the array in rotated rb bits to the right (see rotate.circom)
     * rot_c is the array in rotated rc bits to the right (see rotate.circom)
        - Inputs: in[n] -> array of n bits
                          requires tag binary
        - Output: out[n] -> array of n bits, it takes the value described above
                            satisfies tag binary

*/
*/

template BigSigma(ra, rb, rc) {
    signal input {binary} in[32];
    signal output {binary} out[32];
    var k;

    component rota = RotR(32, ra);
    component rotb = RotR(32, rb);
    component rotc = RotR(32, rc);
    for (k=0; k<32; k++) {
        rota.in[k] <== in[k];
        rotb.in[k] <== in[k];
        rotc.in[k] <== in[k];
    }

    component xor3 = Xor3(32);

    for (k=0; k<32; k++) {
        xor3.a[k] <== rota.out[k];
        xor3.b[k] <== rotb.out[k];
        xor3.c[k] <== rotc.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor3.out[k];
    }
}
