pragma circom 2.0.4;
include "../../circuits/program_constructions/array_access.circom";
include "../../circuits/compconstant.circom";

template Main(n) {
    signal input array[n];
    signal input access;
    signal output value;

    value <== ArrayAccess(n)(array, AddMaxValueTag(n-1)(access));
}

component main = Main(8);
