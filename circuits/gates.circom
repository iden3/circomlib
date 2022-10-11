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
pragma circom 2.0.0;

include "arrayops.circom";
include "bitify.circom";

template XOR() {  //  TODO : needs binary counter example a = 1 and b= 2 ==> out = -1 (wrong)
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - 2*a*b;
}

template AND() {      //TODO do not need {binary} but preserves binary}
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a*b;
}

template OR() {  // TODO : needs binary counter example a = 2 and b= 2 ==> out = 0 (wrong)
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

template NOT() {  //TODO: needs binary
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;  //???? TODO
}

template NAND() {
    signal input a;
    signal input b;
    signal output out;

    out <== 1 - a*b;
}

template NOR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b + 1 - a - b;
}

template MultiAND(n) {
    signal input {binary} in[n];
    signal output {binary} out;

    if (n==1) {
        out <== in[0];
    } else if (n==2) {
        out <== AND()(in[0],in[1]);
    } else {
        var n1 = n\2;
        out <== AND()(MultiAND(n1)(ForceBinaryArray(n1)(Slice (n,0,n1)(in))),MultiAND(n-n1)(ForceBinaryArray(n-n1)(Slice (n,n1,n)(in))));
    }
}


