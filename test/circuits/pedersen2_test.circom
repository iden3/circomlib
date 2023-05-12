pragma circom 2.0.0;

include "../../circuits/pedersen.circom";
include "../../circuits/bitify.circom";


template Main() {
    signal input in;
    signal output out[2];

    component pedersen = Pedersen(256);

    component n2b;
    n2b = Num2Bits(253);

    var i;

    in ==> n2b.in;

    for  (i=0; i<253; i++) {
        pedersen.in[i] <== n2b.out[i];
    }
    signal {binary} aux_0 <== 0;
    for (i=253; i<256; i++) {
        pedersen.in[i] <== aux_0;
    }

    pedersen.out[0] ==> out[0];
    pedersen.out[1] ==> out[1];
}

component main = Main();


