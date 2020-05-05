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

include "../../baby_jubjub/baby_montgomery2edwards/baby_montgomery2edwards.circom"
include "../../baby_jubjub/baby_edwards2montgomery/baby_edwards2montgomery.circom"
include "../../baby_jubjub/baby_montgomery_dbl/baby_montgomery_dbl.circom"
include "_window3.circom";

template Segment3(nWindows) {
    signal input in[nWindows*3];
    signal input base[2];
    signal output out[2];

    var i;
    var j;

    // Convert the base to montgomery

    component e2m = BabyEdwards2Montgomery();
    e2m.in[0] <== base[0];
    e2m.in[1] <== base[1];

    component windows[nWindows];
    component doublers1[nWindows-1];
    component doublers2[nWindows-1];
    component adders[nWindows-1];

    for (i=0; i<nWindows; i++) {
        windows[i] = Window3();
        for (j=0; j<3; j++) {
            // Li passes els tres bits
            windows[i].in[j] <== in[3*i+j];
        }
        if (i==0) {
            // La primera window[0]: P_i
            windows[i].base[0] <== e2m.out[0];
            windows[i].base[1] <== e2m.out[1];
        } else {
            // window[1]: 2^4 P_i
            // window[2]: 2^8 P_i
            // window[3]: 2^8 P_i
            // window[4]: 2^8 P_i
            // ...
            // window[k_i]: 2^(4*k_i) P_i
            // with k_i <= 62
            doublers1[i-1] = BabyMontgomeryDbl();
            doublers2[i-1] = BabyMontgomeryDbl();
            doublers1[i-1].in[0] <== windows[i-1].out4[0];
            doublers1[i-1].in[1] <== windows[i-1].out4[1];
            doublers2[i-1].in[0] <== doublers1[i-1].out[0];
            doublers2[i-1].in[1] <== doublers1[i-1].out[1];
            
            windows[i].base[0] <== doublers2[i-1].out[0];
            windows[i].base[1] <== doublers2[i-1].out[1];

            adders[i-1] = BabyMontgomeryAdd();
            if (i==1) {
                adders[i-1].in1[0] <== windows[0].out[0];
                adders[i-1].in1[1] <== windows[0].out[1];
            } else {
                adders[i-1].in1[0] <== adders[i-2].out[0];
                adders[i-1].in1[1] <== adders[i-2].out[1];
            }
            adders[i-1].in2[0] <== windows[i].out[0];
            adders[i-1].in2[1] <== windows[i].out[1];
        }
    }

    component m2e = BabyMontgomery2Edwards();

    if (nWindows > 1) {
        m2e.in[0] <== adders[nWindows-2].out[0];
        m2e.in[1] <== adders[nWindows-2].out[1];
    } else {
        m2e.in[0] <== windows[0].out[0];
        m2e.in[1] <== windows[0].out[1];
    }

    out[0] <== m2e.out[0];
    out[1] <== m2e.out[1];
}