pragma circom 2.0.0;

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

    SMTVerifier(nLevels)(AddBinaryTag()(enabled), root, siblings, oldKey, oldValue, 
                        AddBinaryTag()(isOld0), key, value,
                        AddBinaryTag()(fnc));
}
component main = SMTVerifier_main(10);
