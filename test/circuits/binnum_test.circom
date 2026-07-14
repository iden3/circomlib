pragma circom 2.1.5;
include "../../circuits/comparators.circom";
include "../../circuits/aliascheck.circom";
include "../../circuits/binnum.circom";
include "../../circuits/tags-managing.circom";


template Main(){
    input signal in;
    input signal inb[254];
    
    BinaryNumber(254)  aux1 <== Num2Bin(254)(in);
    AliasCheck()(aux1.bits);
    aux1.bits === inb;
    
    signal s <== Bin2Num(254)(aux1);
    s === in;

    BinaryNumber(254)  aux2 <== Num2BinNeg(254)(in);
    AliasCheck()(aux2.bits);

    signal iz <== IsZero()(in);
    signal ns <== Bin2Num(254)(aux2);
    ns + iz * 2**254 === 2**254 - in;
}

component main = Main();
