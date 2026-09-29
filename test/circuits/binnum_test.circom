pragma circom 2.1.5;
include "../../circuits/comparators.circom";
include "../../circuits/aliascheck.circom";
include "../../circuits/binnum.circom";
include "../../circuits/tags-managing.circom";


template Main(){
    input signal in;
    input signal inb[254];
    input signal inneg;
    
    BinaryNumber(254)  aux1 <== Num2Bin(254)(in);
    AliasCheck()(aux1.bits);
    aux1.bits === inb;
    
    signal s <== Bin2Num(254)(aux1);
    s === in;

    // Num2BinNeg needs n < maxbits(), so its widest instance is 253, where 2**253 is a
    // genuine integer below the prime and the constraint below means what it says.
    BinaryNumber(253)  aux2 <== Num2BinNeg(253)(inneg);

    signal iz <== IsZero()(inneg);
    signal ns <== Bin2Num(253)(aux2);
    ns + iz * 2**253 === 2**253 - inneg;
}

component main = Main();
