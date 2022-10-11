pragma circom 2.0.0;

include "../../circuits/sha256/sha256_2.circom";

/*
template Main() {
    signal input a;
    signal input b;
    signal output out;

    out <== (a,b);
}

component main = Main();
*/
component main = Sha256_2();
