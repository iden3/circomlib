pragma circom 2.1.5;

include "../../circuits/bitify.circom";
include "../../circuits/tags-managing.circom";

// Num2Bits_strict and Bits2Num_strict both work on maxbits() bits and both
// run an AliasCheck, so they only accept bit patterns below the prime.

template Main(){
    input signal in;
    input signal inb[254];

    output signal {binary} bits[254] <== Num2Bits_strict()(in);
    BinaryNumber(254) inbb <== BinaryCheckArray(254)(inb);
    output signal {maxbit} num <== Bits2Num_strict()(inbb.bits);

    assert(num.maxbit == maxbits());
}

component main = Main();
