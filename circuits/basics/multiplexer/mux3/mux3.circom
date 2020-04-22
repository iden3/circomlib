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

include "../multi_mux3/multi_mux3.circom"

template Mux3() {
    var i;
    signal input c[8];  // Constants
    signal input s[3];   // Selector
    signal output out;

    component mux = MultiMux3(1);

    for (i=0; i<8; i++) {
        mux.c[0][i] <== c[i];
    }

    for (i=0; i<3; i++) {
      s[i] ==> mux.s[i];
    }

    mux.out[0] ==> out;
}
