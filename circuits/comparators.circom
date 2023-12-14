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
include "binsum.circom";
include "gates.circom";

// The templates and functions in this file are general and work for any prime field


/*
*** IsZero(): template that receives an input in representing a field value and returns 1 if the input value is zero, 0 otherwise.
        - Inputs: in -> field value
        - Outputs: out -> in == 0
                          satisfies tag binary
         
    Example: IsZero()(5) = 0, IsZero()(0) = 0
          
*/

template IsZero() {
    signal input in;
    signal output {binary} out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}



/*
*** IsEqual(): template that receives two inputs in[0] and in[1] representing field values and returns 1 if in[0] == in[1], 0 otherwise.
        - Inputs: in[2] -> array of 2 field values
        - Outputs: out -> in[0] == in[1]
                          satisfies tag binary
         
    Example: IsEqual()([5, 2]) = 0, IsZero()([2, 2]) = 0
          
*/

template IsEqual() {
    signal input in[2];
    signal output {binary} out;

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    isz.out ==> out;
}


/*
*** ForceEqualIfEnabled(): template that receives two inputs in[0] and in[1] representing field values and checks that in[0] == in[1] in case enabled == 1
        - Inputs: in[2] -> array of 2 field values
                  enabled -> binary value
                             requires tag binary
        - Outputs: None
         
    Example: ForceEqualIfEnabled()([5, 2], 1) is not satisfiable as in[0] != in[1] and enabled = 1
          
*/

template ForceEqualIfEnabled() {
    signal  input {binary} enabled;
    signal input in[2];

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    (1 - isz.out)*enabled === 0;
}



/*

*** LessThan(n): template that receives two inputs in[0] and in[1] representing field values and returns 1 if in[0] < in[1], 0 otherwise.
        - Inputs: in[2] -> array of 2 field values
                           requires tag maxbit with in.maxbit <= n
        - Outputs: out -> in[0] < in[1]
                          satisfies tag binary
         
    Example: LessThan()([5, 2]) = 0, LessThan()([1, 2]) = 1
          
*/

template LessThan(n) {
    assert(n <= 252);
    signal input {maxbit} in[2];
    signal output {binary} out;
    
    assert(in.maxbit <= n);

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}


/*

*** LessEqThan(n): template that receives two inputs in[0] and in[1] representing field values and returns 1 if in[0] <= in[1], 0 otherwise.
        - Inputs: in[2] -> array of 2 field values
                           requires tag maxbit with in.maxbit <= n
        - Outputs: out -> in[0] <= in[1]
                          satisfies tag binary
         
    Example: LessEqThan()([5, 2]) = 0, LessEqThan()([2, 2]) = 1
          
*/

template LessEqThan(n){
    signal input {maxbit} in[2];
    signal output {binary} out;
    assert(in.maxbit <= n);

    component gt = GreaterThan(n);
    gt.in <== in;
    
    component nt = NOT();
    nt.in <== gt.out;
    nt.out ==> out;

}


/*

*** GreaterThan(n): template that receives two inputs in[0] and in[1] representing field values and returns 1 if in[0] > in[1], 0 otherwise.
        - Inputs: in[2] -> array of 2 field values
                           requires tag maxbit with in.maxbit <= n
        - Outputs: out -> in[0] > in[1]
                          satisfies tag binary
         
    Example: GreaterThan()([5, 2]) = 1, GreaterThan()([2, 2]) = 0
          
*/


template GreaterThan(n) {
    signal input {maxbit} in[2];
    signal output {binary} out;
    
    assert(in.maxbit <= n);

    component lt = LessThan(n);

    lt.in[0] <== in[1];
    lt.in[1] <== in[0];
    lt.out ==> out;
}



/*

*** GreaterEqThan(n): template that receives two inputs in[0] and in[1] representing field values and returns 1 if in[0] >= in[1], 0 otherwise.
        - Inputs: in[2] -> array of 2 field values
                           requires tag maxbit with in.maxbit <= n
        - Outputs: out -> in[0] >= in[1]
                          satisfies tag binary
         
    Example: GreterEqThan()([5, 2]) = 1, GreaterEqThan()([2, 2]) = 1
          
*/

template GreaterEqThan(n) {
    signal input {maxbit} in[2];
    signal output {binary} out;
    
    assert(in.maxbit <= n);

    component gt = LessThan(n);
    gt.in <== in;
    
    component nt = NOT();
    nt.in <== gt.out;
    nt.out ==> out;
}

