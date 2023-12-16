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

// The templates and functions of this file only work for prime field bn128 (21888242871839275222246405745257275088548364400416034343698204186575808495617)



/*
*** CompConstant(ct): template that receives an input in representing a value in binary using 254 bits and checks if its value is greater than the constant value ct given as a parameter
        - Inputs: in[254] -> array of 254 bits
                             requires tag binary
        - Outputs: out -> binary value, out = in > ct
                          satisfies tag binary
 
    Example: CompConstant(10)([0, ..., 0]) = 0, CompConstant(10)([1, ..., 1]) = 1              
          
*/

template CompConstant(ct) {
    signal input {binary} in[254];
    signal output {binary} out;

    signal parts[127];
    signal sout;

    var clsb;
    var cmsb;
    var slsb;
    var smsb;

    var sum=0;

    var b = (1 << 128) -1;
    var a = 1;
    var e = 1;
    var i;

    for (i=0;i<127; i++) {
        clsb = (ct >> (i*2)) & 1;
        cmsb = (ct >> (i*2+1)) & 1;
        slsb = in[i*2];
        smsb = in[i*2+1];

        if ((cmsb==0)&&(clsb==0)) {
            parts[i] <== -b*smsb*slsb + b*smsb + b*slsb;
        } else if ((cmsb==0)&&(clsb==1)) {
            parts[i] <== a*smsb*slsb - a*slsb + b*smsb - a*smsb + a;
        } else if ((cmsb==1)&&(clsb==0)) {
            parts[i] <== b*smsb*slsb - a*smsb + a;
        } else {
            parts[i] <== -a*smsb*slsb + a;
        }

        sum = sum + parts[i];

        b = b -e;
        a = a +e;
        e = e*2;
    }

    sout <== sum;

    component num2bits = Num2Bits(135);

    num2bits.in <== sout;

    out <== num2bits.out[127];
}

/*
*** MaxValueCheck(ct): template that receives an input, checks its value is smaller than or equal to the constant value ct given as a parameter, and returns the same input but with the tag maxvalue with value ct 
        - Inputs: in -> field number
        - Outputs: out -> field number 
                          satisfies tag maxvalue with value ct
*/

template MaxValueCheck(ct){
    signal input in;
    signal output {maxvalue} out;

    signal res <== CompConstant(ct)(Num2Bits(254)(in));
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
    signal output {maxvalue} out;
    
    signal inb[254] <== Num2Bits(254)(in);
    signal res1 <== CompConstant(ct1-1)(inb);
    res1 === 1;
    out.minvalue = ct1;
    signal res2 <== CompConstant(ct2)(inb);
    res2 === 0;    
    out.maxvalue = ct2;
    out <== in;
}
