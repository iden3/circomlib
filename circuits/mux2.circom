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

*** MultiMux2(n): template that implements a multiplexer 4-to-1 between four inputs of n elements
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]
    - If s == 2 then out = c[2]
    - If s == 3 then out = c[3]
    
        - Inputs: s[2] -> binary values, selector
                          requires tag binary
                  c[n][4] -> four arrays of n elements that correspond to the inputs of the mux: c[i][0] => first input, c[i][1] => second input, ... 
        - Output: out[n] -> array of n elements, it takes the value c[i][0] if s == [0, 0], c[i][1] if s == [1, 0], c[i][2] if s == [0, 1], c[i][3] if s == [1, 1]
        
    Example: MultiMux2(3)([[1, 2, 4, 1], [3, 1, 3, 1], [4, 6, 6, 2]], [0, 1]) = [4, 3, 6]

 */
 
template MultiMux2(n) {
    signal input c[n][4];  // Constants
    signal input {binary} s[2];   // Selector
    signal output out[n];

    signal a10[n];
    signal a1[n];
    signal a0[n];
    signal a[n];

    signal  s10;
    s10 <== s[1] * s[0];

    for (var i=0; i<n; i++) {

          a10[i] <==  ( c[i][ 3]-c[i][ 2]-c[i][ 1]+c[i][ 0] ) * s10;
           a1[i] <==  ( c[i][ 2]-c[i][ 0] ) * s[1];
           a0[i] <==  ( c[i][ 1]-c[i][ 0] ) * s[0];
            a[i] <==  ( c[i][ 0] );

          out[i] <==  (  a10[i] +  a1[i] +  a0[i] +  a[i] );

    }
}



/*

*** Mux2(): template that implements a multiplexer 4-to-1 
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]
    - If s == 2 then out = c[2]
    - If s == 3 then out = c[3]

        - Inputs: s[2] -> binary values, selector
                          requires tag binary
                  c[4] -> four elements that correspond to the inputs of the mux: c[0] => first input, c[1] => second input, ...
        - Output: out -> field element, it takes the value c[0] if s == [0, 0], c[1] if s == [1, 0], c[2] if s == [0, 1], c[3] if s == [1, 1] 
        
    Example: Mux2()([1, 5, 4, 2], [1, 1]) = 2

 */

template Mux2() {
    var i;
    signal input c[4];  // Constants
    signal input {binary} s[2];   // Selector
    signal output out;

    component mux = MultiMux2(1);

    for (i=0; i<4; i++) {
        mux.c[0][i] <== c[i];
    }

    for (i=0; i<2; i++) {
      s[i] ==> mux.s[i];
    }

    mux.out[0] ==> out;
}
