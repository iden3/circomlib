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

include "aliascheck.circom";
include "buses.circom";
include "bitify.circom";

/*
*** Num2Bin(n): template that transforms an input into its binary representation using n bits
        - Inputs: in -> field value
        - Output: out -> BinaryNumber(n) bus with the n bits of the  binary representation 
                      It has the bus tag "unique" which indicates that the number represented is below the prime

    Example: Num2Bin(3)(7) = {bits: [1, 1, 1]}
    Note: in case the input in cannot be represented using n bits then the generated system of constraints does not have any solution for that input. 
          For instance, Num2Bin(3)(10) -> no solution
          
*/

template Num2Bin(n) {
    signal input in;
    BinaryNumber(n) output {unique} out;
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out.bits[i] <-- (in >> i) & 1;
        out.bits[i] * (out.bits[i] -1 ) === 0;
        lc1 += out.bits[i] * e2;
        e2 = e2+e2;
    }
    lc1 === in;
    
    if (n == maxbits()) {
       component aliasCheck = AliasCheck();
       aliasCheck.in <== out.bits;
    }
}


/*

*** Bin2Num(n): template that transforms an input bus representing a value x in binary into the decimal representation of x
        - Inputs: in -> BinaryNumber(n) bus with the binary representation of out using n bits
                           requires tag "unique"
        - Output: out -> value represented by the input
                         satisfies tag maxbit with out.maxbit =  n
         
    Example: Bits2Num(3)([1, 0, 1]) = 5
          
*/


template Bin2Num(n) {
    BinaryNumber(n) input {unique} in;
    signal output {maxbit} out;
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i<n; i++) {
        lc1 += in.bits[i] * e2;
        e2 = e2 + e2;
    }
    out.maxbit = n;
    lc1 ==> out;
}


/*
*** Num2BinNeg(n): template that given an input x returns the binary representation of 2 ** n - x using n bits, in case in == 0 then it returns 0
        - Inputs: in -> field value
        - Output: out -> BinaryNumber(n) bus with the  binary representation of 2 ** n - in using n bits  if in != 0,
	                          and all 0's otherwise.
                      It has the bus tag "unique" which indicates that the number represented is below the prime
         
    Example: Num2BitsNeg(3)(2) = [0, 1, 1], Num2Bits(3)(8) = [0, 0, 0]
          
*/

template Num2BinNeg(n) {
    signal input in;
    BinaryNumber(n) output {unique} out;
    var lc1=0;

    component isZero;

    isZero = IsZero();

    var neg = n == 0 ? 0 : 2**n - in;

    for (var i = 0; i<n; i++) {
        out[i] <-- (neg >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * 2**i;
    }
    in ==> isZero.in;
    lc1 + isZero.out * 2**n === 2**n - in;


    if (n == maxbits()) {
       component aliasCheck = AliasCheck();
       aliasCheck.in <== out.bits;
    }

}
