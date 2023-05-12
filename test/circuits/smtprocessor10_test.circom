pragma circom 2.0.0;

include "../../circuits/smt/smtprocessor.circom";
include "../../circuits/tags-managing.circom";


template Main() {
    signal input oldRoot;
    signal input siblings[10];
    signal input oldKey;
    signal input oldValue;
    signal input isOld0;
    signal input newKey;
    signal input newValue;
    signal input fnc[2];
    
    signal output newRoot;

    newRoot <== SMTProcessor(10)(oldRoot, siblings, oldKey, oldValue, AddBinaryTag()(isOld0), newKey, newValue, AddBinaryArrayTag(2)(fnc));

    
}

component main = Main();
