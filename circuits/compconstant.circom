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

include "bitify.circom";

// Returns 1 if in (in binary) > ct

template CompConstant(ct) {
    signal input in[254];
    signal output out;
    signal parts[127];
    
    var ct_l;
    var ct_u;
    var sig_l;
    var sig_u;

    var acc=0;

    var a = 1;

    for (var i=0;i<127; i++) {
        ct_l = (ct >> (i*2)) & 1;
        ct_u = (ct >> (i*2+1)) & 1;
        sig_l = in[i*2];
        sig_u = in[i*2+1];

        if (ct_l == 0 && ct_u == 0) {
            parts[i] <== sig_l + sig_u - sig_l*sig_u;
        } else if (ct_l == 1 && ct_u == 0) {
            parts[i] <==  sig_l + 2*sig_u - sig_l*sig_u - 1;
        } else if (ct_l == 0 && ct_u ==1) {
            parts[i] <==  sig_l*sig_u + sig_u - 1;
        } else parts[i] <==  sig_l*sig_u - 1;

        acc = acc + parts[i]*a;
        a = a * 2;
    }

    acc = acc + a - 1;

    component num2bits = Num2Bits(128);
    num2bits.in <== acc;
    out <== num2bits.out[127];
}

