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
*** XOR(): template that given two inputs a and b representing booleans (0 or 1) returns the value of a XOR b
        - Inputs: a -> binary value
                       requires tag binary
                  b -> binary value
                       requires tag binary
        - Output: out -> binary value, result of a XOR b
                            satisfies tag binary
         
    Example: XOR()(1, 1) = 0
*/

template XOR() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a + b - 2*a*b;
}

/*
*** AND(): template that given two inputs a and b representing booleans (0 or 1) returns the value of a AND b
        - Inputs: a -> binary value
                       requires tag binary
                  b -> binary value
                       requires tag binary
        - Output: out -> binary value, result of a AND b
                            satisfies tag binary
         
    Example: AND()(1, 1) = 1
*/

template AND() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a*b;
}


/*
*** OR(): template that given two inputs a and b representing booleans (0 or 1) returns the value of a OR b
        - Inputs: a -> binary value
                       requires tag binary
                  b -> binary value
                       requires tag binary
        - Output: out -> binary value, result of a OR b
                            satisfies tag binary
         
    Example: OR()(1, 0) = 1
*/

template OR() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a + b - a*b;
}


/*
*** NOT(): template that given an input in representing a boolean (0 or 1) returns the value of NOT in
        - Inputs: in -> binary value
                       requires tag binary
        - Output: out -> binary value, result of NOT in
                            satisfies tag binary
         
    Example: NOT()(1) = 0
*/

template NOT() {
    signal input {binary} in;
    signal output {binary} out;

    out <== 1 + in - 2*in;
}

/*
*** NAND(): template that given two inputs a and b representing booleans (0 or 1) returns the value of a NAND b
        - Inputs: a -> binary value
                       requires tag binary
                  b -> binary value
                       requires tag binary
        - Output: out -> binary value, result of a NAND b
                            satisfies tag binary
         
    Example: NAND()(1, 1) = 0
*/

template NAND() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== 1 - a*b;
}


/*
*** NOR(): template that given two inputs a and b representing booleans (0 or 1) returns the value of a NOR b
        - Inputs: a -> binary value
                       requires tag binary
                  b -> binary value
                       requires tag binary
        - Output: out -> binary value, result of a NOR b
                            satisfies tag binary
         
    Example: NOR()(1, 0) = 0
*/

template NOR() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a*b + 1 - a - b;
}

/*
*** MultiAND(n): template that given as input an array of n signals representing booleans (0 or 1) in[0], ... , in[n-1] and returns the value of and[0] AND and[1] ... AND and[n-1] 
        - Inputs: in[n] -> binary values
                           requires tag binary
        - Output: out[n] -> binary value, result of in[0] AND ... AND in[n-1]
                            satisfies tag binary
         
    Example: MultiAND(4)([1, 1, 0, 1]) = 0
*/

template MultiAND(n) {
    signal input {binary} in[n];
    signal output {binary} out;
    component and1;
    component and2;
    component ands[2];
    if (n==1) {
        out <== in[0];
    } else if (n==2) {
        and1 = AND();
        and1.a <== in[0];
        and1.b <== in[1];
        out <== and1.out;
    } else {
        and2 = AND();
        var n1 = n\2;
        var n2 = n-n\2;
        ands[0] = MultiAND(n1);
        ands[1] = MultiAND(n2);
        var i;
        for (i=0; i<n1; i++) ands[0].in[i] <== in[i];
        for (i=0; i<n2; i++) ands[1].in[i] <== in[n1+i];
        and2.a <== ands[0].out;
        and2.b <== ands[1].out;
        out <== and2.out;
    }
}


