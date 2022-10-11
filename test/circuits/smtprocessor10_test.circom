pragma circom 2.0.0;

include "../../circuits/smt/smtprocessor.circom";
include "../../circuits/bitify.circom";

template Main(n) {
    signal input oldRoot;
    signal output newRoot;
    signal input siblings[n];
    signal input oldKey;
    signal input oldValue;
    signal input isOld0;
    signal input newKey;
    signal input newValue;
    signal input fnc[2];

    newRoot <== SMTProcessor(n)(oldRoot,siblings,oldKey,oldValue,isOld0,newKey,newValue,AddBinaryArrayTag(2)(fnc));
}

component main = Main(10);
