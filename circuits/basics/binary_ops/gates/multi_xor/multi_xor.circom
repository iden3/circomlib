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

include "../../../bitify/num2bits/num2bits.circom";

// Output true iff an odd number of inputs are true.
template MultiXOR(n) {
    signal input in[n];
    signal output out;

    var sum = 0;

    for(var i=0; i<n; i++) {
        sum = sum + in[i];
    }

    component n2b = Num2Bits(n); //This should not be n but log_2(n). 

    n2b.in <== sum;

    out <== n2b.out[0];
}