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

include "compconstant.circom";

/*
Used tags:
binary: is a tag without value that indicates that the signal should have a binary value (0 or 1);
        Formally: if x has tag binary then x*(x-1) === 0 is expected to be true
	(although it's not checked by the compiler)
*/

// states that the number in binary (unsigned) is smaller than or equal to P-1

template AliasCheck() {
    signal input {binary} in[254];

    var aux = CompConstant(-1)(in);
    aux === 0;
}
