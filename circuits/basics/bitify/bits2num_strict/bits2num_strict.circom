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

include "../../aliascheck/aliascheck.circom";
include "../bits2num/bits2num.circom"

template Bits2Num_strict() {
    signal input in[n];
    signal output out;

    component aliasCheck = AliasCheck();
    component b2n = Bits2Num(254);

    for (var i=0; i<254; i++) {
        in[i] ==> b2n.in[i];
        in[i] ==> aliasCheck.in[i];
    }

    b2n.out ==> out;
}