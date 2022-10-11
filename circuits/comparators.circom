//DONE
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

include "bitify.circom";
include "compconstant.circom";
include "gates.circom";
include "binsum.circom";

/*
Used tags:
binary: is a tag without value that indicates that the signal should have a binary value (0 or 1);
Formally: if x has tag binary then x*(x-1) === 0 is expected to be true (although it's not checked by the compiler)

maxbit: is a tag with value that indicates maximum number of bits needed to represent the signal value;
        Formally: if x has tag maxbit with value m then there should exist x_0...x_{m-1} with x_i*(x_i-1) === 0 s.t.
        x = sum_{i=0}^{n-1} x_i * 2**i (although it's not checked by the compiler)

In all these templates if the inputs fulfil the conditions associated to their tags then
the outputs fulfil the conditions associated to their tags
*/

template IsZero() {
    signal input in;
    signal output {binary} out;

    signal inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}

template IsNegative() {
    // check if a signal is negative in circom sense
    signal input in;
    signal output {binary} out;
    var max = -1 >> 1;
    CompConstant(max)(Num2Bits(NeededBits(-1))(in)) ==> out;
}

template IsEqual() {
    signal input in[2];
    signal output {binary} out;

    IsZero()(in[1] - in[0]) ==> out;
}

template ForceEqualIfEnabled() {
    signal input enabled;
    signal input in[2];

    var aux = IsZero()(in[1] - in[0]);
    (1 - aux)*enabled === 0;
}

// n is the number of bits the input  have.
// Only works if the distance between the two numbers is less than 2^n (TODO check)
template LessThan(n) {
    assert(n < NeededBits(-1) - 1); // To be sure the check works
    signal input in[2];
    signal output {binary} out;

    var aux[n+1] = Num2Bits(n+1)(in[0]+ (1<<n) - in[1]);
    out <== 1-aux[n];
}

// n is the number of bits the input  have.
// Only works if the distance between the two numbers is less than 2^n (TODO check)
template GreaterThan(n) {
    signal input in[2];
    signal output {binary} out;
    
    var aux[2];
    aux[0] = in[1];
    aux[1] = in[0];
    LessThan(n)(aux) ==> out;
}

// works for all numbers (needs more constraints)
template LessThan_strict () {
    signal input in[2];
    signal output {binary} out;

    IsNegative()(in[0]-in[1]) ==> out;

}

template GreaterThan_strict () {
    signal input in[2];
    signal output {binary} out;

    var aux[2];
    aux[0] = in[1];
    aux[1] = in[0];
    LessThan_strict()(aux) ==> out;
}


// n is the number of bits the input  have.
template LessEqThan(n) {
    signal input in[2];
    signal output {binary} out;

    out <== NOT()(GreaterThan(n)(in));
}

template LessEqThan_strict() {
    signal input in[2];
    signal output {binary} out;

    NOT()(GreaterThan_strict()(in)) ==> out;
}

// n is the number of bits the input  have.
template GreaterEqThan(n) {
    signal input in[2];
    signal output {binary} out;

    NOT()(LessThan(n)(in)) ==> out;
}

template GreaterEqThan_strict() {
    signal input in[2];
    signal output {binary} out;

    NOT()(LessEqThan_strict()(in)) ==> out;
}

template LessThan_general() {
    signal input {maxbit} in[2];
    signal output {binary} out;

    if (in.maxbit < NeededBits(-1) - 1) {
        LessThan(in.maxbit)(in) ==> out;
    } else {
        LessThan_strict()(in) ==> out;
    }
}

template LessEqThan_general() {
    signal input {maxbit} in[2];
    signal output {binary} out;

    if (in.maxbit < NeededBits(-1) - 1) {
        LessEqThan(in.maxbit)(in) ==> out;
    } else {
        LessEqThan_strict()(in) ==> out;
    }
}

template GreaterThan_general() {
    signal input {maxbit} in[2];
    signal output {binary} out;

    if (in.maxbit < NeededBits(-1) - 1) {
        GreaterThan(in.maxbit)(in) ==> out;
    } else {
        GreaterThan_strict()(in) ==> out;
    }
}

template GreaterEqThan_general() {
    signal input {maxbit} in[2];
    signal output {binary} out;

    if (in.maxbit < NeededBits(-1) - 1) {
        GreaterEqThan(in.maxbit)(in) ==> out;
    } else {
        GreaterEqThan_strict()(in) ==> out;
    }
}
