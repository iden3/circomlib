pragma circom 2.0.0;
include "../../circuits/aliascheck.circom";


template Main() {
    signal input in[254];

//    component bincheck[254];
//    for (var i = 0; i<254; i++) {
//        bincheck[i] = AddBinaryCheck();
//	bincheck[i].in <== in[i];
//    }
    signal {binary} aux[254];
    aux <== in;
    component achk = AliasCheck();
    achk.in <== aux;
}

component main = Main();
