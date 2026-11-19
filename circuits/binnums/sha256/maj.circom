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

/* Maj function for sha256

out = a&b ^ a&c ^ b&c  =>

out = a*b   +  a*c  +  b*c  -  2*a*b*c  =>

out = a*( b + c - 2*b*c ) + b*c =>

mid = b*c
out = a*( b + c - 2*mid ) + mid

*/
pragma circom 2.0.0;

include "../../buses.circom";

template Maj_t(n) {
    BinaryNumber(n) input a;
    BinaryNumber(n) input b;
    BinaryNumber(n) input c;
    BinaryNumber(n) output out;
    BinaryNumber(n) mid;

    for (var k=0; k<n; k++) {
        mid.bits[k] <== b.bits[k]*c.bits[k];
        out.bits[k] <== a.bits[k] * (b.bits[k]+c.bits[k]-2*mid.bits[k]) + mid.bits[k];
    }
}
