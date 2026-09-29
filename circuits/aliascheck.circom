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

include "comparators.circom";
include "buses.circom";
include "bitify.circom";

// The templates and functions of this file only work for any prime field


/*
*** AliasCheck(): template that receives an input in representing a value in binary using maxbits() bits and checks that the value belongs to the prime field (that is, if in represents the value x in binary, then the template checks that x <= p-1). It returns the same bits carrying the tag unique.
        - Inputs: in[maxbits()] -> array of maxbits() bits
                                   requires tag binary
        - Outputs: out[maxbits()] -> the same bits
                                     satisfies tags binary and unique

    Why the output matters: a maxbits()-bit vector does not determine a field element. For
    x < 2**maxbits() - p the bits of x and of x + p are both valid decompositions of x, so a
    template that gives the bits a field meaning (Sign, for instance) can be steered by the
    choice of decomposition. The tag unique records that this check was done, so such a
    template can require it.
         
    Example: in case we are working in the prime field with p = 11, then AliasCheck()([1, 0, 0, 1]) is satisfiable as 9 < 11, but AliasCheck()([1, 0, 1, 1]) is not as 13 >= 11. In the second case the executable program (C or WASM) reaches a false assert, and the generated R1CS is not satisfiable
          
*/


template AliasCheck() {

    input signal {binary} in[maxbits()];
    output signal {binary, unique} out[maxbits()];

    component  compConstant = CompConstant(maxbits(), -1);

    compConstant.in <== in;

    compConstant.out === 0;

    out <== in;
}
