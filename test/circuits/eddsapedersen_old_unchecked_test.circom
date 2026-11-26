pragma circom 2.1.5;

include "../../circuits/eddsapedersen_old.circom";
include "../../circuits/tags-managing.circom";

// A caller that moves raw bits straight into BinaryPoint buses. Declaring a
// BinaryPoint grants {binary} to its fields without any constraint, so this
// compiles with no BinaryCheckArray; the verifier must check the bits itself.
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

    signal {binary} msg_aux[n] <== BinaryCheckArray(n)(msg);
    for (var i = 0; i < 254; i++){
        A_aux.binY[i] <== A[i];
        R8_aux.binY[i] <== R8[i];
        S_aux.binY[i] <== S[i];
    }
    A_aux.signX <== A[255];
    R8_aux.signX <== R8[255];
    S_aux.signX <== S[255];

    EdDSAPedersenVerifier(n)(msg_aux, A_aux, R8_aux, S_aux);
}

component main = A(8);
