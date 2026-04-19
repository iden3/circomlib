pragma circom 2.1.5;

include "../../circuits/eddsapedersen.circom";
include "../../circuits/tags-managing.circom";

template A(n){
    signal input msg[n];

    input signal A[256];
    input signal R8[256];
    input signal S[256];

    A[254] === 0;
    R8[254] === 0;
    S[254] === 0;
    
    BinaryPoint(254) A_aux;
    BinaryPoint(254) R8_aux;
    BinaryPoint(254) S_aux;

    signal {binary} msg_aux[n] <==  BinaryCheckArray(n)(msg);
    component check_a = BinaryCheckArray(255);
    for (var i = 0; i < 254; i++){
        check_a.in[i] <== A[i];
    }
    check_a.in[254] <== A[255];
    for (var i = 0; i < 254; i++){
        check_a.out[i] ==> A_aux.binY[i];
    }
    check_a.out[254] ==> A_aux.signX;
    
    component check_R8 = BinaryCheckArray(255);
    for (var i = 0; i < 254; i++){
        check_R8.in[i] <== R8[i];
    }
    check_R8.in[254] <== R8[255];
    for (var i = 0; i < 254; i++){
        check_R8.out[i] ==> R8_aux.binY[i];
    }
    check_R8.out[254] ==> R8_aux.signX;
    
    component check_S = BinaryCheckArray(255);
    for (var i = 0; i < 254; i++){
        check_S.in[i] <== S[i];
    }
    check_S.in[254] <== S[255];
    for (var i = 0; i < 254; i++){
        check_S.out[i] ==> S_aux.binY[i];
    }
    check_S.out[254] ==> S_aux.signX;

    
    EdDSAPedersenVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);

}

component main = A(80);

