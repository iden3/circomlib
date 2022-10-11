pragma circom 2.0.0;

include "../../circuits/escalarmul.circom";
include "../../circuits/bitify.circom";


template Main() {
    signal input in[256];
    signal output out[2];

    var i;

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553, 16950150798460657717958625567821834550301663161624707787222815936182638968203];

    EscalarMul(256, base)(AddBinaryArrayTag(256)(in),[0,1]) ==> out;
}

component main = Main();
