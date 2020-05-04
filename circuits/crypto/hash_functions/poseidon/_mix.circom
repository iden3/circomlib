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

template Mix(t, M) {
    signal input in[t];
    signal output out[t];
    var lc;

    var i;
    var j;

    for (i=0; i<t; i++) {
        lc = 0;
        for (j=0; j<t; j++) {
            lc = lc + M[i][j]*in[j];
        }
        out[i] <== lc;
    }
}