pragma circom 2.0.0;

include "../../circuits/mux1.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    signal output out[2];

    out[0] <== 37;
    out[1] <== 47;
}

template Main() {
    var i;
    signal input selector;//private
    signal output out;

    component n2b = Num2Bits(1);

    selector ==> n2b.in;

    out <== Mux1()(Constants()(), n2b.out[0]);

}

component main = Main();
