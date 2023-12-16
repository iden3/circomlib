pragma circom 2.1.5;

include "../../circuits/smt/smtverifier.circom";
include "../../circuits/tags-managing.circom";

template SMTVerifier_main(nLevels) {
    signal input enabled;
    signal input root;
    signal input siblings[nLevels];
    signal input oldKey;
    signal input oldValue;
    signal input isOld0;
    signal input key;
    signal input value;
    signal input fnc;

    SMTVerifier(nLevels)(BinaryCheck()(enabled), root, siblings, oldKey, oldValue, 
                        BinaryCheck()(isOld0), key, value,
                        BinaryCheck()(fnc));
}
component main = SMTVerifier_main(10);
