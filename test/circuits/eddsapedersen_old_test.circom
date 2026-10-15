pragma circom 2.1.5;

include "../../circuits/eddsapedersen_old.circom";
include "../../circuits/tags-managing.circom";
include "../../circuits/buses.circom";

template A(n){
    signal input msg[n];

    input signal A[256];
    input signal R8[256];
    input signal S[256];

    BinaryPoint(254) A_aux;
    BinaryPoint(254) R8_aux;
    BinaryPoint(254) S_aux;

    BinaryNumber(n) msg_aux <==  BinaryCheckArray(n)(msg);
    component check_a = BinaryCheckArray(256);
    check_a.in <== A;
    for (var i = 0; i < 254; i++){
        check_a.out.bits[i] ==> A_aux.binY[i];
    }
    check_a.out.bits[254] === 0;
    check_a.out.bits[255] ==> A_aux.signX;
    component check_R8 = BinaryCheckArray(256);
    check_R8.in <== R8;
    for (var i = 0; i < 254; i++){
        check_R8.out.bits[i] ==> R8_aux.binY[i];
    }
    check_R8.out.bits[254] === 0;
    check_R8.out.bits[255] ==> R8_aux.signX;
    component check_S = BinaryCheckArray(256);
    check_S.in <== S;
    for (var i = 0; i < 254; i++){
        check_S.out.bits[i] ==> S_aux.binY[i];
    }
    check_S.out.bits[254] === 0;
    check_S.out.bits[255] ==> S_aux.signX;

    
    EdDSAPedersenVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);

}

component main = A(80);

