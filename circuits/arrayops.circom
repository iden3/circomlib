// DONE
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

// returns the slice [m..r) of an array [0..n)
template Slice (n,m,r) {
    assert(0 <= m);
    assert(m <= r);
    assert(r <= n);

    signal input in[n];
    signal output out[r-m];

    for (var i = m; i < r; i++) {
        out[i-m] <== in[i];
    }
}

//concatenates two arrays
template Concat (n,m) {
    signal input in1[n];
    signal input in2[m];
    signal output out[n+m];

    for (var i = 0; i < n; i++) {
        out[i] <== in1[i];
    }
    for (var i = 0; i < m; i++) {
        out[n+i] <== in2[i];
    }
}

// repeat a signal n times
template Repeat (n) {
    signal input in;
    signal output out[n];

    for (var i = 0; i < n; i++) {
        out[i] <== in;
    }
}

    