/*
    Assume sel is binary.

    If sel == 0 then outL = L and outR=R
    If sel == 1 then outL = R and outR=L

 */

template Switcher() {
    signal input sel;
    signal input L;
    signal input R;
    signal output outL;
    signal output outR;

    signal aux;

    aux <== (R-L)*sel;    // We create aux in order to have only one multiplication
    outL <==  aux + L;
    outR <== -aux + R;
}
