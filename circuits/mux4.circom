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

*** MultiMux4(n): template that implements a multiplexer 16-to-1 between 16 inputs of n elements
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]
       .
       .
       .
       
    - If s == 14 then out = c[14]
    - If s == 15 then out = c[15]
    
        - Inputs: s[4] -> binary values, selector
                          requires tag binary
                  c[n][16] -> 16 arrays of n elements that correspond to the inputs of the mux: c[i][0] => first input, c[i][1] => second input, ... 
        - Output: out[n] -> array of n elements, it takes the value c[i][0] if s == [0, 0, 0, 0], c[i][1] if s == [1, 0, 0, 0], ... , c[i][15] if s == [1, 1, 1, 1]
        
    Example: MultiMux4(2)([[1, 2, 4, 1, 1, 6, 7, 3, 1, 2, 4, 1, 1, 6, 7, 3], [3, 1, 3, 1, 4, 6, 6, 2, 1, 2, 4, 1, 1, 6, 7, 3]], [1, 0, 1, 0]) = [6, 6]

 */

template MultiMux4(n) {
    signal input c[n][16];  // Constants
    signal input {binary} s[4];   // Selector
    signal output out[n];

    signal a3210[n];
    signal a321[n];
    signal a320[n];
    signal a310[n];
    signal a32[n];
    signal a31[n];
    signal a30[n];
    signal a3[n];

    signal a210[n];
    signal a21[n];
    signal a20[n];
    signal a10[n];
    signal a2[n];
    signal a1[n];
    signal a0[n];
    signal a[n];

    // 4 constrains for the intermediary variables
    signal  s10;
    s10 <== s[1] * s[0];
    signal  s20;
    s20 <== s[2] * s[0];
    signal  s21;
    s21 <== s[2] * s[1];
    signal s210;
    s210 <==  s21 * s[0];


    for (var i=0; i<n; i++) {

        a3210[i] <==  ( c[i][15]-c[i][14]-c[i][13]+c[i][12] - c[i][11]+c[i][10]+c[i][ 9]-c[i][ 8]
                       -c[i][ 7]+c[i][ 6]+c[i][ 5]-c[i][ 4] + c[i][ 3]-c[i][ 2]-c[i][ 1]+c[i][ 0] ) * s210;
         a321[i] <==  ( c[i][14]-c[i][12]-c[i][10]+c[i][ 8] - c[i][ 6]+c[i][ 4]+c[i][ 2]-c[i][ 0] ) * s21;
         a320[i] <==  ( c[i][13]-c[i][12]-c[i][ 9]+c[i][ 8] - c[i][ 5]+c[i][ 4]+c[i][ 1]-c[i][ 0] ) * s20;
         a310[i] <==  ( c[i][11]-c[i][10]-c[i][ 9]+c[i][ 8] - c[i][ 3]+c[i][ 2]+c[i][ 1]-c[i][ 0] ) * s10;
          a32[i] <==  ( c[i][12]-c[i][ 8]-c[i][ 4]+c[i][ 0] ) * s[2];
          a31[i] <==  ( c[i][10]-c[i][ 8]-c[i][ 2]+c[i][ 0] ) * s[1];
          a30[i] <==  ( c[i][ 9]-c[i][ 8]-c[i][ 1]+c[i][ 0] ) * s[0];
           a3[i] <==  ( c[i][ 8]-c[i][ 0] );

         a210[i] <==  ( c[i][ 7]-c[i][ 6]-c[i][ 5]+c[i][ 4] - c[i][ 3]+c[i][ 2]+c[i][ 1]-c[i][ 0] ) * s210;
          a21[i] <==  ( c[i][ 6]-c[i][ 4]-c[i][ 2]+c[i][ 0] ) * s21;
          a20[i] <==  ( c[i][ 5]-c[i][ 4]-c[i][ 1]+c[i][ 0] ) * s20;
          a10[i] <==  ( c[i][ 3]-c[i][ 2]-c[i][ 1]+c[i][ 0] ) * s10;
           a2[i] <==  ( c[i][ 4]-c[i][ 0] ) * s[2];
           a1[i] <==  ( c[i][ 2]-c[i][ 0] ) * s[1];
           a0[i] <==  ( c[i][ 1]-c[i][ 0] ) * s[0];
            a[i] <==  ( c[i][ 0] );

          out[i] <== ( a3210[i] + a321[i] + a320[i] + a310[i] + a32[i] + a31[i] + a30[i] + a3[i] ) * s[3] +
                     (  a210[i] +  a21[i] +  a20[i] +  a10[i] +  a2[i] +  a1[i] +  a0[i] +  a[i] );


    }
}



/*

*** Mux4(): template that implements a multiplexer 16-to-1 
    - If s == 0 then out = c[0]
    - If s == 1 then out = c[1]
      . 
      .
      .
      
    - If s == 14 then out = c[14]
    - If s == 15 then out = c[15]

        - Inputs: s[4] -> binary values, selector
                          requires tag binary
                  c[16] -> 16 elements that correspond to the inputs of the mux: c[0] => first input, c[1] => second input, ...
        - Output: out -> field element, it takes the value c[0] if s == [0, 0, 0, 0], c[1] if s == [1, 0, 0, 0], . . ., c[15] if s == [1, 1, 1, 1] 
        
    Example: Mux3()([1, 5, 4, 2, 6, 3, 1, 5, 1, 5, 4, 2, 6, 3, 1, 5], [0, 0, 1, 1]) = 6

 */

template Mux4() {
    var i;
    signal input c[16];  // Constants
    signal input {binary} s[4];   // Selector
    signal output out;

    component mux = MultiMux4(1);

    for (i=0; i<16; i++) {
        mux.c[0][i] <== c[i];
    }

    for (i=0; i<4; i++) {
      s[i] ==> mux.s[i];
    }

    mux.out[0] ==> out;
}
