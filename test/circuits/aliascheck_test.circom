pragma circom 2.2.0;
include "../../circuits/aliascheck.circom";
include "../../circuits/tags-managing.circom";


template Main(){
    input signal in[254];
    
    component ac = AliasCheck();
    ac.in <== BinaryCheckArray(254)(in);


}

component main = Main();
