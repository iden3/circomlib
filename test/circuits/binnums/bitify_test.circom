pragma circom 2.1.5;
include "../../../circuits/binnums/bitify.circom";
include "../../../circuits/binnums/binnum.circom";
include "../../../circuits/buses.circom";

template Main(n) {
    signal input in;

    BinaryNumber(n) {unique} aux <== Num2Bin(n)(in);
    signal {maxbit} aux2 <== Bin2Num(n)(aux);
    assert(aux2.maxbit == n);
    in === aux2;

    // Exposed so the decomposition itself can be checked, not only the fact
    // that Num2Bin and Bin2Num undo each other.
    output signal {binary} out[n] <== aux.bits;
}

component main = Main(30);
