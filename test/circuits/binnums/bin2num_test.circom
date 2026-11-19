pragma circom 2.1.5;

include "../../../circuits/binnums/binnum.circom";
include "../../../circuits/binnums/tags-managing.circom";

// Bin2Num on bits that did not come from Num2Bin: BinaryCheckArray grants binary only.
// At 8 bits nothing else is needed; at maxbits() Bin2Num alias-checks the bits itself.

template Main(){
    input signal in8[8];
    input signal in254[254];

    output signal out8 <== Bin2Num(8)(BinaryCheckArray(8)(in8));
    output signal out254 <== Bin2Num(254)(BinaryCheckArray(254)(in254));
}

component main = Main();
