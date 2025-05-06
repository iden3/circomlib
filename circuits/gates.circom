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

/*
Boolean logic gates.

Inputs generally must be constrained to 0 or 1, using Num2Bits or a*(a-1) === 0 etc.
Most languages extend boolean logic to non boolean types, but using non-booleans here will lead to subtle soundness bugs.
*/

// Requires binary inputs: [2,2] -> -4, should be 0
template XOR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - 2*a*b;
}

// Applies to non-binary numbers: gives non-zero output iff both inputs are non-zero because a and b are coprime with p
template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

// Requires binary inputs: [2,2] -> 0, should be non-zero
template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

// Requires binary inputs: 2 -> -1, should be 0
template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

// Requires binary inputs: [2,1] -> -1, should be 0
template NAND() {
    signal input a;
    signal input b;
    signal output out;

    out <== 1 - a*b;
}

// Requires binary inputs: [2,1] -> 0, should be non-zero
template NOR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b + 1 - a - b;
}

template MultiAND(n) {
    signal input in[n];
    signal output out;
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


