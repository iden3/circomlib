pragma circom 2.1.5;

include "../../circuits/eddsapedersen.circom";
include "../../circuits/tags-managing.circom";

template A(n){
    signal input msg[n];

    input signal A[255];
    input signal R8[255];
    input signal S[255];
    
    BinaryPoint(254) A_aux;
    BinaryPoint(254) R8_aux;
    BinaryPoint(254) S_aux;

    signal {binary} msg_aux[n] <==  BinaryCheckArray(n)(msg);
    component check_a = BinaryCheckArray(255);
    check_a.in <== A;
    for (var i = 0; i < 254; i++){
        check_a.out[i] ==> A_aux.binY[i];
    }
    check_a.out[254] ==> A_aux.signX;
    component check_R8 = BinaryCheckArray(255);
    check_R8.in <== R8;
    for (var i = 0; i < 254; i++){
        check_R8.out[i] ==> R8_aux.binY[i];
    }
    check_R8.out[254] ==> R8_aux.signX;
    component check_S = BinaryCheckArray(255);
    check_S.in <== S;
    for (var i = 0; i < 254; i++){
        check_S.out[i] ==> S_aux.binY[i];
    }
    check_S.out[254] ==> S_aux.signX;

    
    EdDSAPedersenVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);

}

component main = A(80);

