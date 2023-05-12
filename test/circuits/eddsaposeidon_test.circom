pragma circom 2.1.5;

include "../../circuits/eddsaposeidon.circom";
include "../../circuits/tags-managing.circom";

template A(){
    signal input enabled;
    signal input Ax; // point in Edwards representation
    signal input Ay;

    signal input S;
    signal input R8x; // point in Edwards representation
    signal input R8y;

    signal input M; // mesage 
    
    signal enabled_aux <== AddBinaryTag()(enabled);
    
    EdDSAPoseidonVerifier()(enabled_aux, Ax, Ay, S, R8x, R8y, M);


}

component main = A();
