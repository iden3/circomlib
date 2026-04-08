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
include "bitify.circom";


// The templates and functions in this file are general and work for any prime field



/*
*** BinaryCheck(n): template that adds the constraints needed to ensure that a signal in is binary and adds the tag binary to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including binary tag
                         satisfies tag binary
         
    Example: BinaryCheck()(1) = 1
    Note: in case the input in is not binary then the generated system of constraints does not have any solution for that input. 
          For instance, BinaryCheck()(10) -> no solution
          
*/

template BinaryCheck () {
    input signal in;
    output signal {binary} out;

    in * (in - 1) === 0;
    out <== in;
}

/*
*** BinaryCheckArray(n): template that adds the constraints needed to ensure that all signal of an array of n elements are binary and adds the tag binary to the input
        - Inputs: in[n] -> array of n field elements
        - Output: out[n] -> same value as in, but including binary tag
                         satisfies tag binary
         
    Example: BinaryCheckArray(2)([0,1]) = [0,1]
    Note: in case the input contains a non binary element then the generated system of constraints does not have any solution for that input. 
          For instance, BinaryCheckArray(2)([0,10]) -> no solution
          
*/

template BinaryCheckArray(n) {
    input signal in[n];
    output signal {binary} out[n];

    for (var i = 0; i < n; i++) {
    	out[i] <== BinaryCheck()(in[i]);
    }
}


/*
*** MaxbitCheck(n): template that adds the constraints needed to ensure that a signal can be expressed using n bits(that is, that is value is in [0, 2**n)) and adds the tag maxbit = n to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including maxbit tag with out.maxbit = n
                         satisfies tag out.maxbit = n
         
    Example: MaxbitCheck(5)(14) = 14
    Note: in case the input in does not satisfy the specification of maxbit then the generated system of constraints does not have any solution for that input. 
          For instance, MaxbitCheck(3)(100) -> no solution
          
*/

template MaxbitCheck(n) {
    input signal in;
    output signal {maxbit} out;
    
    _ <== Num2Bits(n)(in);

    out.maxbit = n;
    out <== in;
}

/*
*** MaxbitCheckArray(n): template that adds the constraints needed to ensure that the signals an array of length m can be expressed using n bits(that is, that is value is in [0, 2**n)) and adds the tag maxbit = n to the input
        - Inputs: in[m] -> array of m field values
        - Output: out[m] -> same values as in, but including maxbit tag with out.maxbit = n
                         satisfies tag out.maxbit = n
         
    Example: MaxbitCheckArray(5, 2)([3,14]) = [3, 14] with tag maxbit = 5
    Note: in case the a signal of the input in does not satisfy the specification of maxbit then the generated system of constraints does not have any solution for that input. 
          For instance, MaxbitCheckArray(3, 2)([3, 100]) -> no solution
          
*/


template MaxbitCheckArray(n,m) {
    input signal in[m];
    output signal {maxbit} out[m];

    out.maxbit = n;

    for (var i = 0; i < m; i++) {
       out[i] <== MaxbitCheck(n)(in[i]);
    }
    
}


/*
*** MaxValueCheck(ct): template that receives an input, checks its value is smaller than or equal to the constant value ct given as a parameter, and returns the same input but with the tag maxvalue with value ct 
        - Inputs: in -> field number
        - Outputs: out -> field number 
                          satisfies tag maxvalue with value ct

    Example: MaxValueCheck(15)(14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of max then the generated system of constraints does not have any solution for that input. 
          For instance, MaxValueCheck(3)(100) -> no solution
*/

template MaxValueCheck(ct){
    input signal in;
    output signal {maxvalue} out;

    signal res <== CompConstant(nbits(ct), ct)(Num2Bits(nbits(ct))(in));
    res === 0;
    out.maxvalue = ct;
    out <== in;
}

/*
*** MinValueCheck(ct): template that receives an input, checks its value is greater than or equal to the constant value ct given as a parameter, and returns the same input but with the tag minvalue with value ct 
        - Inputs: in -> field number
        - Outputs: out -> field number 
                          satisfies tag minvalue with value ct
*/

template MinValueCheck(ct){
    input signal in;
    output signal {minvalue} out;

    signal res <== CompConstant(maxbits(), ct-1)(Num2Bits(maxbits())(in));
    res === 1;
    out.minvalue = ct;
    out <== in;
}

/*
*** MinMaxValueCheck(ct): template that receives an input, checks its value is greater than or equal to the constant value ct1 given as a first parameter and smaller than or equal to the constant value ct2 given as a second parameter, and returns the same input but with the tag minvalue with value ct1 and the tag maxvalue with value ct2 
        - Inputs: in -> field number
        - Outputs: out -> field number 
                          satisfies tag minvalue with value ct1
                          satisfies tag maxvalue with value ct2
*/

template MinMaxValueCheck(ct1,ct2){
    input signal in;
    output signal {minvalue,maxvalue} out;

    var n = nbits(ct2);
    
    signal inb[n] <== Num2Bits(n)(in);
    signal res1 <== CompConstant(n, ct1-1)(inb);
    res1 === 1;
    out.minvalue = ct1;
    signal res2 <== CompConstant(n, ct2)(inb);
    res2 === 0;    
    out.maxvalue = ct2;
    out <== in;
}

/*
*** MaxAbsValueTagCheck(n): template that adds the constraints needed to ensure that the absolute value of a signal is smaller or equal than a given value n and adds the tag max_abs = n to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including max_abs tag with out.max_abs = n
                         satisfies tag out.max_abs = n
         
    Example: MaxValueTagCheck(15)(-14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of max_abs then the generated system of constraints does not have any solution for that input. 
          For instance, MaxAbsValueTagCheck(33)(-100) -> no solution
          
*/

template MaxAbsValueTagCheck(n){
    input signal in;
    output signal {max_abs} out;
    
    var needed_bits = nbits(2 * n);
    
    signal {maxbit} aux[2];
    aux.maxbit = needed_bits;
    aux[0] <== MaxbitCheck(needed_bits)(in + n); // to ensure that 0 <= aux[0] < 2**nbits(2 * n)
    aux[1] <== 2 * n;

    signal out1 <== LessEqThan(n)(aux); // checks that 0 <= in + n <= 2 * n <==> -n <= in <= n
    out1 === 1;
    
    out.max_abs = n;
    out <== in;
}

