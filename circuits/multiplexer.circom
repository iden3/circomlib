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

// --> Assignation without constraint
// <-- Assignation without constraint
// === Constraint
// <== Assignation with constraint
// ==> Assignation with constraint
// All variables are members of the field F[p]
// https://github.com/zcash-hackworks/sapling-crypto
// https://github.com/ebfull/bellman

/*
function log2(a) {
    if (a==0) {
        return 0;
    }
    let n = 1;
    let r = 1;
    while (n<a) {
        r++;
        n *= 2;
    }
    return r;
}
*/

pragma circom 2.0.0;

include "matrixops.circom";

template EscalarProduct(w) {
    signal input in1[w];
    signal input in2[w];
    signal output out;
    signal aux[w];
    var lc = 0;
    for (var i=0; i<w; i++) {
        aux[i] <== in1[i]*in2[i];
        lc = lc + aux[i];
    }
    out <== lc;
}

//revise
// if inp < w then out[inp] == 1 and out[x] == 0 for all x!=inp
// otherwise out[x] == 0 for all 0 <= x <= w

// constraints only state this
// out[x] == 0 for all 0 <= x <= w and x!=inp
// 0<= success <= 1 and success = sum out

// possible solution all zeros

// constraints says implies
// code says if and only if
template Decoder(w) {
    signal input inp;
    signal output out[w];
    signal output success;
    var lc=0;

    for (var i=0; i<w; i++) {
        out[i] <-- (inp == i) ? 1 : 0;
        out[i] * (inp-i) === 0;
        lc = lc + out[i];
    }

    lc ==> success;
    success * (success -1) === 0;
}

template Multiplexer(wIn, nIn) {
    signal input inp[nIn][wIn];
    signal input sel;
    signal output out[wIn];

    signal dec_out[nIn], dec_success;
    (dec_out, dec_success) <== Decoder(nIn)(sel);
    
    signal inp_trans[wIn][nIn];
    inp_trans <== Transpose(nIn, wIn)(inp);
    
    for (var j=0; j<wIn; j++) {
	out[j] <== EscalarProduct(nIn)(inp_trans[j], dec_out);
    }
    
    dec_success === 1;
}
