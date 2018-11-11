include "../../circuit/escalarmul.circom";
include "../../node_modules/circom/circuits/sha256/bitify.circom";


template Main() {
    signal input in;
    signal output out[2];

    component n2b = Num2Bits(253);
    component escalarMul = EscalarMul(253);

    var i;

    in ==> n2b.in;

    for  (i=0; i<253; i++) {
        n2b.out[i] ==> escalarMul.in[i];
    }

    escalarMul.out[0] ==> out[0];
    escalarMul.out[1] ==> out[1];
}

component main = Main();
