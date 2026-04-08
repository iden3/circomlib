pragma circom 2.1.5;

include "../../circuits/smt/smtprocessor.circom";
include "../../circuits/tags-managing.circom";


template Main() {
    input signal oldRoot;
    input signal siblings[10];
    input signal oldKey;
    input signal oldValue;
    input signal isOld0;
    input signal newKey;
    input signal newValue;
    input signal fnc[2];
    
    output signal newRoot;

    newRoot <== SMTProcessor(10)(oldRoot, siblings, oldKey, oldValue, BinaryCheck()(isOld0), newKey, newValue, BinaryCheckArray(2)(fnc));

    
}

component main = Main();
