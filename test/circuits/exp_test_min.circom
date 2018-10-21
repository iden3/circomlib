include "../../circuit/exp.circom";


template Main() {
    signal input in[256];
    signal output out[2];

    var i;

    component exp = Exp(256);

    for  (i=0; i<256; i++) {
        in[i] ==> exp.in[i];
    }

    exp.out[0] ==> out[0];
    exp.out[1] ==> out[1];
}

component main = Main();
