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

include "../../baby_jubjub/baby_montgomery_add/baby_montgomery_add.circom"
include "../../baby_jubjub/baby_montgomery_dbl/baby_montgomery_dbl.circom"
include "../../../basics/multiplexer/multi_mux2/multi_mux2.circom";

template Window3() {
    signal input in[3];
    signal input base[2];
    signal output out[2];
    signal output out4[2];   // Returns 4*Base (To be linked)

    component mux = MultiMux2(2);

    mux.s[0] <== in[0];
    mux.s[1] <== in[1];

    component dbl2 = BabyMontgomeryDbl();
    component adr3 = BabyMontgomeryAdd();
    component adr4 = BabyMontgomeryAdd();

// in[0]  -> 1*BASE

    mux.c[0][0] <== base[0];
    mux.c[1][0] <== base[1];

// in[1] -> 2*BASE
    dbl2.in[0] <== base[0];
    dbl2.in[1] <== base[1];
    mux.c[0][1] <== dbl2.out[0];
    mux.c[1][1] <== dbl2.out[1];

// in[2] -> 3*BASE
    adr3.in1[0] <== base[0];
    adr3.in1[1] <== base[1];
    adr3.in2[0] <== dbl2.out[0];
    adr3.in2[1] <== dbl2.out[1];
    mux.c[0][2] <== adr3.out[0];
    mux.c[1][2] <== adr3.out[1];

// in[3] -> 4*BASE
    adr4.in1[0] <== base[0];
    adr4.in1[1] <== base[1];
    adr4.in2[0] <== adr3.out[0];
    adr4.in2[1] <== adr3.out[1];
    mux.c[0][3] <== adr4.out[0];
    mux.c[1][3] <== adr4.out[1];

    out4[0] <== adr4.out[0];
    out4[1] <== adr4.out[1];

    out[0] <== mux.out[0];
    out[1] <== - mux.out[1]*2*in[2] + mux.out[1];  // Negate it if in[2] is one
}