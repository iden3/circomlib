include "../../circuit/exp.circom";
include "../../node_modules/circom/circuits/sha256/bitify.circom";


template Main() {
    signal input in;
    signal output out[2];

    component n2b = Num2Bits(253);
    component exp = Exp(253);

    var i;

    in ==> n2b.in;

    for  (i=0; i<253; i++) {
        n2b.out[i] ==> exp.in[i];
    }

    exp.out[0] ==> out[0];
    exp.out[1] ==> out[1];
}

component main = Main();
