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
*** AliasCheck(): template that receives an input in representing a value in binary using 254 bits and checks that the value belongs to the prime field (that is, if in represents the value x in binary, then the template checks that x <= p-1)
        - Inputs: in[254] -> array of 254 bits
                                   requires tag binary
        - Outputs: None
         
    Example: in case we are working in the prime field with p = 11, then AliasCheck()([1, 0, 0, 1]) is satisfiable as 9 < 11, but AliasCheck()([1, 0, 1, 1]) is not as 13 >= 11. In the second case the executable program (C or WASM) reaches a false assert, and the generated R1CS is not satisfiable
          
*/


template AliasCheck() {

    signal input {binary} in[254];

    component  compConstant = CompConstant(-1);

    for (var i=0; i<254; i++) in[i] ==> compConstant.in[i];

    compConstant.out === 0;
}
