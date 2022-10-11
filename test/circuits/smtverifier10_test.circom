pragma circom 2.0.0;

include "../../circuits/smt/smtverifier.circom";

template Main(n) {
    signal input enabled;
    signal input root;
    signal input siblings[n];
    signal input oldKey;
    signal input oldValue;
    signal input isOld0;
    signal input key;
    signal input value;
    signal input fnc;

    SMTVerifier(10)(
    enabled,
    root,
    siblings,
    oldKey,
    oldValue,
    isOld0,
    key,
    value,
    AddBinaryTag()(fnc)
    );
}
    
component main = Main(10);
