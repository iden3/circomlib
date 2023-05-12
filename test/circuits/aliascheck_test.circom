pragma circom 2.0.0;
include "../../circuits/aliascheck.circom";
include "../../circuits/tags-managing.circom";


template Main(){
    signal input in[254];
    
    component ac = AliasCheck();
    ac.in <== AddBinaryArrayTag(254)(in);


}

component main = Main();
