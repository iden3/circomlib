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

include "bitify.circom";
include "../buses.circom";

// The templates and functions in this file are general and work for any prime field

/*

*** BinSum(n, ops): template that receives ops inputs of n bits representing values in[0], ..., in[ops-1] in binary and returns n + nbits(ops) bits representing the result of in[0] + ... + in[ops - 1]
        - Inputs: in[ops] -> ops BinaryNumber(n) buses representing the values in[0], ... , in[ops - 1] using n bits
                             their bits require tag binary
        - Output: out -> BinaryNumber(nbits((2**n - 1) * ops)) bus with the result of in[0] + ... + in[ops - 1]
                         its bits satisfy tag binary
         
    Example: BinSum(3, 3)([[1, 0, 1], [1, 1, 1], [0, 0, 1]]) = [0, 0, 0, 0, 1]
    
    
    Main Constraint:
        in[0][0]     * 2^0  +  in[0][1]     * 2^1  + ..... + in[0][n-1]    * 2^(n-1)  +
        + in[1][0]     * 2^0  +  in[1][1]     * 2^1  + ..... + in[1][n-1]    * 2^(n-1)  +
        + ..
        + in[ops-1][0] * 2^0  +  in[ops-1][1] * 2^1  + ..... + in[ops-1][n-1] * 2^(n-1)  +
        ===
        out[0] * 2^0  + out[1] * 2^1 +   + out[n+e-1] *2(n+e-1)

    To waranty output binarys:

        out[0]     * (out[0] - 1) === 0
        out[1]     * (out[0] - 1) === 0
        .
        .
        .  
        out[n+e-1] * (out[n+e-1] - 1) == 0
          
*/

template BinSum(n, ops) {
    var nout = nbits((2**n -1)*ops);
    BinaryNumber(n) input in[ops];
    BinaryNumber(nout) output out;

    var lin = 0;
    var lout = 0;

    var k;
    var j;

    var e2;

    e2 = 1;
    for (k=0; k<n; k++) {
        for (j=0; j<ops; j++) {
            lin += in[j].bits[k] * e2;
        }
        e2 = e2 + e2;
    }

    e2 = 1;
    for (k=0; k<nout; k++) {
        out.bits[k] <-- (lin >> k) & 1;

        // Ensure out is binary
        out.bits[k] * (out.bits[k] - 1) === 0;

        lout += out.bits[k] * e2;

        e2 = e2+e2;
    }

    // Ensure the sum;

    lin === lout;
}
