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

/*

*** Maj_t(n): template that receives three inputs of n bits and returns for each i = 0..n out[i] = 1 in case at least two of a the values of a[i], b[i] and c[i] are 1, and 0 otherwise
 
        - Inputs: a[n] -> array of n bits
                          requires tag binary
                  b[n] -> array of n bits
                          requires tag binary
                  c[n] -> array of n bits
                          requires tag binary
        - Output: out[n] -> array of n bits, it takes the value: 
                                out[i] = a[i] & b[i] \/ a[i] & c[i] \/ b[i] & c[i]
                            satisfies tag binary
        
    Example:    a b c   out
                0 0 0    0
                0 0 1    0
                0 1 0    0
                0 1 1    1
                1 0 0    0
                1 0 1    1
                1 1 0    1
                1 1 1    1
 */

template Maj_t(n) {
    signal input {binary} a[n];
    signal input {binary} b[n];
    signal input {binary} c[n];
    signal output {binary} out[n];
    signal {binary} mid[n];

    for (var k=0; k<n; k++) {
        mid[k] <== b[k]*c[k];
        out[k] <== a[k] * (b[k]+c[k]-2*mid[k]) + mid[k];
    }
}
