include "../../circuit/escalarmul.circom";


template Main() {
    signal input in[256];
    signal output out[2];

    var i;

    component escalarMul = EscalarMul(256);

    for  (i=0; i<256; i++) {
        in[i] ==> escalarMul.in[i];
    }

    escalarMul.out[0] ==> out[0];
    escalarMul.out[1] ==> out[1];
}

component main = Main();
