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

include "comparators.circom";

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

// in case inp >= w then witness = 0, in other case witness = 1, out[i] = 1 if i = inp and 0 otherwise
/* 
Specification:
  - Success := w < inp
  - for i in 0..w: out[i] = 1 if i = inp, else out[i] = 0 
*/

template Decoder(w) {
    signal input inp;
    signal output out[w];
    signal output success;
    var lc=0;
    
    component checkZero[w];

    for (var i=0; i<w; i++) {
        checkZero[i] = IsZero();
        checkZero[i].in <== inp - i;
        out[i] <== checkZero[i].out;
        lc = lc + out[i];
    }

    lc ==> success;
}

// in case inp >= w does not accept any solution -> does not generate witness
/* 
Specification:
  In case inp < w:
     - for i in 0..w: out[i] = 1 if i = inp, else out[i] = 0 
  If w >= inp => the sysetm of constraints does not have any solution
*/
template Decoder_strict(w) {
    signal input inp;
    signal output out[w];
    var lc=0;

    for (var i=0; i<w; i++) {
        out[i] <-- (inp == i) ? 1 : 0;
        out[i] * (inp-i) === 0;
        lc = lc + out[i];
    }

    lc === 1;
}



template Multiplexer(wIn, nIn) {
    signal input inp[nIn][wIn];
    signal input sel;
    signal output out[wIn];
    component dec = Decoder_strict(nIn);
    component ep[wIn];

    for (var k=0; k<wIn; k++) {
        ep[k] = EscalarProduct(nIn);
    }

    sel ==> dec.inp;
    for (var j=0; j<wIn; j++) {
        for (var k=0; k<nIn; k++) {
            inp[k][j] ==> ep[j].in1[k];
            dec.out[k] ==> ep[j].in2[k];
        }
        ep[j].out ==> out[j];
    }
}

