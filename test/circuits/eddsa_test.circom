pragma circom 2.0.0;

include "../../circuits/eddsa.circom";


template A(n){
    signal input msg[n];

    signal input A[256];
    signal input R8[256];
    signal input S[256];

    signal {binary} msg_aux[n] <== msg;
    signal {binary} A_aux[256] <== A;
    signal {binary} R8_aux[256] <== R8;
    signal {binary} S_aux[256] <== S;
    
    EdDSAVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);

}

component main = A(80);
