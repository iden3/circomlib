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
pragma circom 2.1.5;

include "compconstant.circom";

// The templates and functions of this file only work for prime field bn128 (21888242871839275222246405745257275088548364400416034343698204186575808495617)


/*
*** Sign(): template that receives an input in representing a value in binary using 254 bits and checks if the value is positive or negative. We consider a number positive in case in <= p \ 2 and negative otherwise 
        - Inputs: in[254] -> array of 254 bits
                             requires tag binary
        - Outputs: sign -> 0 in case in <= prime \ 2, 1 otherwise
                           satisfies tag binary
         
          
*/

template Sign() {
    signal input {binary} in[254];
    signal output {binary} sign;

    component comp = CompConstant(10944121435919637611123202872628637544274182200208017171849102093287904247808);

    var i;

    for (i=0; i<254; i++) {
        comp.in[i] <== in[i];
    }

    sign <== comp.out;
}
