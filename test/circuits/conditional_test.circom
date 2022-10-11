pragma circom 2.0.8;

include "../../circuits/comparators.circom";
include "../../circuits/program_constructions/conditionals.circom";


template Main() {
    signal input in1;
    signal input in2;
    signal input in3;
    signal output out;

    out <== ConditionalConstraint()(IsZero()(in1),in2,in3);
}

component main = Main();
