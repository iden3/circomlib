pragma circom 2.2.0;


bus Point(){
    signal x;
    signal y;
}


bus BinaryPoint(n) {
    signal {binary} binY[n];
    signal {binary} signX;
}



bus BinaryNumber(n){
    signal {binary} bits[n];
}

