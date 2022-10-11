pragma circom 2.0.0;

include "../../circuits/eddsa.circom";

template Main(n) {
    signal input msg[n];

    signal input A[256];
    signal input R8[256];
    signal input S[256];
    
    EdDSAVerifier(n)(msg,AddBinaryArrayTag(256)(A),AddBinaryArrayTag(256)(R8),AddBinaryArrayTag(256)(S));
}

component main = Main(80);
