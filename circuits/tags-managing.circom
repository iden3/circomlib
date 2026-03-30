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
    signal input in;
    signal output {binary} out;

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
    signal input in[n];
    signal output {binary} out[n];

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
    signal input in;
    signal output {maxbit} out;
    
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
    signal input in[m];
    signal output {maxbit} out[m];

    out.maxbit = n;

    for (var i = 0; i < m; i++) {
       out[i] <== MaxbitCheck(n)(in[i]);
    }
    
}


/*
*** MaxValueCheck(ct): template that adds the constraints needed to ensure that a signal is smaller or equal than a given value ct and adds the tag maxvalue = ct to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including max tag with out.maxvalue = ct
                         satisfies tag out.maxvalue = ct
         
    Example: MaxValueCheck(15)(14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of maxvalue then the generated system of constraints does not have any solution for that input. 
          For instance, MaxValueCheck(3)(100) -> no solution
          
*/

template MaxValueCheck(ct) {
    signal input in;
    signal output {maxvalue} out;
    
    signal {maxbit} aux[2];
    aux.maxbit = nbits(ct);
    aux[0] <== MaxbitCheck(nbits(ct))(in); // to ensure the correct size
    aux[1] <== ct;

    signal out1 <== LessEqThan(nbits(ct))(aux);
    out1 === 1;
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
    signal input in;
    signal output {minvalue} out;

    signal res <== CompConstant(ct-1)(Num2Bits(254)(in));
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
    signal input in;
    signal output {minvalue, maxvalue} out;
    
    assert(0 <= ct1 && ct1 <= ct2);
    
    signal checked_in <== MaxbitCheck(nbits(ct2))(in); // to ensure the correct size
    
    signal {maxbit} aux_min[2];
    aux_min.maxbit = nbits(ct2);
    aux_min[0] <== ct1;
    aux_min[1] <== checked_in;
    signal out1 <== LessEqThan(nbits(ct1))(aux_min);
    out1 === 1;
    out.minvalue = ct1;
    
    signal {maxbit} aux_max[2];
    aux_max.maxbit = nbits(ct2);
    aux_max[0] <== checked_in;
    aux_max[1] <== ct2;
    signal out2 <== LessEqThan(nbits(ct2))(aux_max);
    out2 === 1;
    out.maxvalue = ct2;
    
    out <== in;
}




/*
*** AddMaxAbsValueTag(ct): template that adds the constraints needed to ensure that the absolute value of a signal is smaller or equal than a given value ct and adds the tag max_abs = ct to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including max_abs tag with out.max_abs = ct
                         satisfies tag out.max_abs = ct
         
    Example: AddMaxValueTag(15)(-14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of max_abs then the generated system of constraints does not have any solution for that input. 
          For instance, AddMaxAbsValueTag(33)(-100) -> no solution
          
*/

template AddMaxAbsValueTag(ct){
    signal input in;
    signal output {maxabsvalue} out;
    
    var needed_bits = nbits(2 * ct);
    
    signal {maxbit} aux[2];
    aux.maxbit = needed_bits;
    aux[0] <== MaxbitCheck(needed_bits)(in + ct); // to ensure that 0 <= aux[0] < 2**nbits(2 * ct)
    aux[1] <== 2 * ct;

    signal out1 <== LessEqThan(needed_bits)(aux); // checks that 0 <= in + ct <= 2 * ct <==> -ct <= in <= ct
    out1 === 1;
    
    out.maxabsvalue = ct;
    out <== in;
}



