pragma circom 2.1.5;

include "../../circuits/pedersen_old.circom";
include "../../circuits/bitify.circom";


template Main() {
    input signal in[2];
    output Point {babyedwards} pout;

    component pedersen = Pedersen(250*2);

    component n2b[2];
    n2b[0] = Num2Bits(250);
    n2b[1] = Num2Bits(250);

    var i;

    in[0] ==> n2b[0].in;
    in[1] ==> n2b[1].in;

    for  (i=0; i<250; i++) {
        n2b[0].out[i] ==> pedersen.in[i];
        n2b[1].out[i] ==> pedersen.in[250+i];
    }

    pedersen.pout ==> pout;
}

component main = Main();
