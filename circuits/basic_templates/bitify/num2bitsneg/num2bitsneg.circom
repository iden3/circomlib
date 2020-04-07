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

include "../../comparators/iszero/iszero.circom";

template Num2BitsNeg(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    component isZero;

    isZero = IsZero();

    var neg = n == 0 ? 0 : 2**n - in;

    for (var i = 0; i<n; i++) {
        out[i] <-- (neg >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * 2**i;
    }

    in ==> isZero.in;



    lc1 + isZero.out * 2**n === 2**n - in;
}
