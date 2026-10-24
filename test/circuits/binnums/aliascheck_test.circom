pragma circom 2.1.5;
include "../../../circuits/binnums/aliascheck.circom";
include "../../../circuits/binnums/tags-managing.circom";


template Main(){
    input signal in[254];
    
    component ac = AliasCheck();
    ac.in <== BinaryCheckArray(254)(in);


}

component main = Main();
