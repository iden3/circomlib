pragma circom 2.1.5;

include "../../circuits/smt/smtverifier.circom";
include "../../circuits/tags-managing.circom";

template SMTVerifier_main(nLevels) {
    input signal enabled;
    input signal root;
    input signal siblings[nLevels];
    input signal oldKey;
    input signal oldValue;
    input signal isOld0;
    input signal key;
    input signal value;
    input signal fnc;

    SMTVerifier(nLevels)(BinaryCheck()(enabled), root, siblings, oldKey, oldValue, 
                        BinaryCheck()(isOld0), key, value,
                        BinaryCheck()(fnc));
}
component main = SMTVerifier_main(10);
