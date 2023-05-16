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

// To consult the tags specifications check tags-specifications.circom


/*
*** AddBinaryTag(n): template that adds the constraints needed to ensure that a signal in is binary and adds the tag binary to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including binary tag
                         satisfies tag binary
         
    Example: AddBinaryTag()(1) = 1
    Note: in case the input in is not binary then the generated system of constraints does not have any solution for that input. 
          For instance, AddBinaryTag()(10) -> no solution
          
*/

template AddBinaryTag () {
    signal input in;
    signal output {binary} out;

    in * (in - 1) === 0;
    out <== in;
}

/*
*** AddBinaryArrayTag(n): template that adds the constraints needed to ensure that all signal of an array of n elements are binary and adds the tag binary to the input
        - Inputs: in[n] -> array of n field elements
        - Output: out[n] -> same value as in, but including binary tag
                         satisfies tag binary
         
    Example: AddBinaryArrayTag(2)([0,1]) = [0,1]
    Note: in case the input contains a non binary element then the generated system of constraints does not have any solution for that input. 
          For instance, AddBinaryArrayTag(2)([0,10]) -> no solution
          
*/

template AddBinaryArrayTag(n) {
    signal input in[n];
    signal output {binary} out[n];

    for (var i = 0; i < n; i++) {
    	out[i] <== AddBinaryTag()(in[i]);
    }
}

/*
*** ForceBinary(n): template that adds the tag binary to a signal without adding the constraints needed to ensure that the signal is binary
        - Inputs: in -> field value
        - Output: out -> same value as in, but including binary tag
                         DOES NOT CHECK THAT out satisfies tag binary
         
    Example: ForceBinary()(5) = 5
    Note: the template does not check if the input actually satisfies the binary specification --> Use carefully, potentially dangerous template
          For instance, ForceBinary()(10) = 10, including tag binary
          
*/

template ForceBinary() {
    signal input in;
    signal output {binary} out;

    out <== in;
}

/*
*** ForceBinaryArray(n): template that adds the tag binary to an array of n signals without adding the constraints needed to ensure that the signals are binary
        - Inputs: in[n] -> array of field values
        - Output: out[n] -> same value as in, but including binary tag
                         DOES NOT CHECK THAT out satisfies tag binary
         
    Example: ForceBinaryArray()([1,0]) = [1, 0], including tag binary
    Note: the template does not check if the input actually satisfies the binary specification --> Use carefully, potentially dangerous template
          For instance, ForceBinaryArray()([0, 10]) = [0, 10], including tag binary
          
*/

template ForceBinaryArray(n) {
    signal input in[n];
    signal output {binary} out[n];

    out <== in;
}

/*
*** AddMaxbitTag(n): template that adds the constraints needed to ensure that a signal can be expressed using n bits(that is, that is value is in [0, 2**n)) and adds the tag maxbit = n to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including maxbit tag with out.maxbit = n
                         satisfies tag out.maxbit = n
         
    Example: AddMaxbitTag(5)(14) = 14
    Note: in case the input in does not satisfy the specification of maxbit then the generated system of constraints does not have any solution for that input. 
          For instance, AddMaxbitTag(3)(100) -> no solution
          
*/

template AddMaxbitTag(n) {
    signal input in;
    signal output {maxbit} out;
    
    _ <== Num2Bits(n)(in);

    out.maxbit = n;
    out <== in;
}

/*
*** AddMaxbitArrayTag(n): template that adds the constraints needed to ensure that the signals an array of length m can be expressed using n bits(that is, that is value is in [0, 2**n)) and adds the tag maxbit = n to the input
        - Inputs: in[m] -> array of m field values
        - Output: out[m] -> same values as in, but including maxbit tag with out.maxbit = n
                         satisfies tag out.maxbit = n
         
    Example: AddMaxbitTag(5, 2)([3,14]) = [3, 14] with tag maxbit = 5
    Note: in case the a signal of the input in does not satisfy the specification of maxbit then the generated system of constraints does not have any solution for that input. 
          For instance, AddMaxbitTag(3, 2)([3, 100]) -> no solution
          
*/


template AddMaxbitArrayTag(n,m) {
    signal input in[m];
    signal output {maxbit} out[m];

    out.maxbit = n;

    for (var i = 0; i < m; i++) {
       out[i] <== AddMaxbitTag(n)(in[i]);
    }
    
}

/*
*** ForceMaxbitTag(n): template that adds the tag maxbit = n to the input without adding any constraints to ensure that the input especification of the tag
        - Inputs: in -> field value
        - Output: out -> same value as in, but including maxbit tag with out.maxbit = n
                         DOES NOT CHECK THAT out satisfies tag out.maxbit = n
         
    Note: the template does not check if the input actually satisfies the maxbit specification --> Use carefully, potentially dangerous template
          For instance, ForceMaxbitTag(2)(10) = 10, including tag maxbit = 2
          
*/


template ForceMaxbit(n) {
    signal input in;
    signal output {maxbit} out;

    out.maxbit = n;
    in ==> out;
}

/*
*** ForceMaxbitArrayTag(n, m): template that adds the tag maxbit = n to the input that is an array of m signals without adding any constraints to ensure that the inputs especification of the tag
        - Inputs: in[m] -> field value
        - Output: out[m] -> same value as in, but including maxbit tag with out.maxbit = n
                         DOES NOT CHECK THAT out satisfies tag out.maxbit = n
         
    Note: the template does not check if the input actually satisfies the maxbit specification --> Use carefully, potentially dangerous template
          For instance, ForceMaxbitTag(2,2)([0,10]) = [0,10], including tag maxbit = 2
          
*/

template ForceMaxbitArray(n,m) {
    signal input in[m];
    signal output {maxbit} out[m];

    out.maxbit = n;
    
    in ==> out;
}


/*
*** AddMaxValueTag(n): template that adds the constraints needed to ensure that a signal is smaller or equal than a given value n and adds the tag max = n to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including max tag with out.max = n
                         satisfies tag out.max = n
         
    Example: AddMaxValueTag(15)(14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of max then the generated system of constraints does not have any solution for that input. 
          For instance, AddMaxValueTag(3)(100) -> no solution
          
*/

template AddMaxValueTag(n) {
    signal input in;
    signal output {max} out;
    
    signal {maxbit} aux[2];
    aux.maxbit = nbits(n);
    aux[0] <== AddMaxbitTag(nbits(n))(in); // to ensure the correct size
    aux[1] <== n;

    signal out1 <== LessEqThan(n)(aux);
    out1 === 1;
    out.max = n;
    out <== in;
}

/*
*** AddMaxAbsValueTag(n): template that adds the constraints needed to ensure that the absolute value of a signal is smaller or equal than a given value n and adds the tag max_abs = n to the input
        - Inputs: in -> field value
        - Output: out -> same value as in, but including max_abs tag with out.max_abs = n
                         satisfies tag out.max_abs = n
         
    Example: AddMaxValueTag(15)(-14) = 14 and can be satisfied
    Note: in case the input in does not satisfy the specification of max_abs then the generated system of constraints does not have any solution for that input. 
          For instance, AddMaxAbsValueTag(33)(-100) -> no solution
          
*/

template AddMaxAbsValueTag(n){
    signal input in;
    signal output {max_abs} out;
    
    var needed_bits = nbits(2 * n);
    
    signal {maxbit} aux[2];
    aux.maxbit = needed_bits;
    aux[0] <== AddMaxbitTag(needed_bits)(in + n); // to ensure that 0 <= aux[0] < 2**nbits(2 * n)
    aux[1] <== 2 * n;

    signal out1 <== LessEqThan(n)(aux); // checks that 0 <= in + n <= 2 * n <==> -n <= in <= n
    out1 === 1;
    
    out.max_abs = n;
    out <== in;
}


