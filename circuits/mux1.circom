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

// The templates and functions in this file are general and work for any prime field

/*

*** MultiMux1(n): template that implements a multiplexer 2-to-1 between two inputs of n elements
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]

        - Inputs: s -> binary value, selector
                       requires tag binary
                  c[n][2] -> two arrays of n elements that correspond to the inputs of the mux: c[i][0] => first input, c[i][1] => second input 
        - Output: out[n] -> array of n elements, it takes the value c[i][0] if s == 0, c[i][1] if s == 1 
        
    Example: MultiMux1(3)([[1, 2], [3, 1], [4, 6]], 1) = [2, 1, 6]

 */

template MultiMux1(n) {
    signal input c[n][2];  // Constants
    signal input {binary} s;   // Selector
    signal output out[n];

    for (var i=0; i<n; i++) {

        out[i] <== (c[i][1] - c[i][0])*s + c[i][0];

    }
}


/*

*** Mux1: template that implements a multiplexer 2-to-1 
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]

        - Inputs: s -> binary value, selector
                       requires tag binary
                  c[2] -> two elements that correspond to the inputs of the mux: c[0] => first input, c[1] => second input 
        - Output: out -> field element, it takes the value c[0] if s == 0, c[1] if s == 1 
        
    Example: Mux1()([1, 5], 0) = 1

 */

template Mux1() {
    var i;
    signal input c[2];  // Constants
    signal input {binary} s;   // Selector
    signal output out;

    component mux = MultiMux1(1);

    for (i=0; i<2; i++) {
        mux.c[0][i] <== c[i];
    }

    s ==> mux.s;

    mux.out[0] ==> out;
}
