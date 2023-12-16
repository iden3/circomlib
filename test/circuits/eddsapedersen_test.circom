pragma circom 2.1.5;

include "../../circuits/eddsapedersen.circom";
include "../../circuits/tags-managing.circom";


template A(n){
    signal input msg[n];

    signal input A[256];
    signal input R8[256];
    signal input S[256];

    signal {binary} msg_aux[n] <==  BinaryCheckArray(n)(msg);
    signal {binary} A_aux[256] <==  BinaryCheckArray(256)(A);
    signal {binary} R8_aux[256] <==  BinaryCheckArray(256)(R8);
    signal {binary} S_aux[256] <==  BinaryCheckArray(256)(S);
    
    EdDSAPedersenVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);

}

component main = A(80);
