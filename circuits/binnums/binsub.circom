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

include "../buses.circom";

// The templates and functions in this file are general and work for any prime field


/*

*** BinSub(n): template that receives two inputs of n bits representing values in[0] and in[1] in binary and returns n bits representing the result of in[0] - in[1]
        - Inputs: in[2] -> two BinaryNumber(n) buses representing the values in[0] and in[1] using n bits
                           their bits require tag binary
        - Output: out -> BinaryNumber(n) bus with the result of in[0] - in[1] expressed using n bits
                         its bits satisfy tag binary
         
    Example: BinSub(3)([[1, 0, 1], [1, 1, 1]]) = [0, 1, 1]
    
    
    Main Constraint:
       (in[0][0]     * 2^0  +  in[0][1]     * 2^1  + ..... + in[0][n-1]    * 2^(n-1))  +
       +  2^n
       - (in[1][0]     * 2^0  +  in[1][1]     * 2^1  + ..... + in[1][n-1]    * 2^(n-1))
       ===
       out[0] * 2^0  + out[1] * 2^1 +   + out[n-1] *2^(n-1) + aux * 2^n


       out[0]     * (out[0] - 1) === 0
       out[1]     * (out[0] - 1) === 0
       .
       .
       .
       out[n-1]   * (out[n-1] - 1) === 0
       aux * (aux-1) == 0
          
*/


template BinSub(n) {
    BinaryNumber(n) input in[2];
    BinaryNumber(n) output out;

    signal aux;

    var lin = 2**n;
    var lout = 0;

    var i;

    for (i=0; i<n; i++) {
        lin = lin + in[0].bits[i]*(2**i);
        lin = lin - in[1].bits[i]*(2**i);
    }

    for (i=0; i<n; i++) {
        out.bits[i] <-- (lin >> i) & 1;

        // Ensure out is binary
        out.bits[i] * (out.bits[i] - 1) === 0;

        lout = lout + out.bits[i]*(2**i);
    }

    aux <-- (lin >> n) & 1;
    aux*(aux-1) === 0;
    lout = lout + aux*(2**n);

    // Ensure the sum;
    lin === lout;
}
