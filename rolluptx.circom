/*
fnc[0]  fn[1]   Function    S1  S2  S3  S4
0       0       NOP         0   0   0   0
0       1       TRANSFER    0   1   0   1
1       0       ENTRY       0   1   0   1
1       1       EXIT        1   0   1   1

*/

template rollupTx(nLevels) {
    signal input fromIdx;                       // 24
    signal input toIdx;                         // 24
    signal input fpTxAmount;                    // 24

    signal input fnc[2];                        // 2

    signal oldRoot;
    signal newRoot;

    signal input sigR8;
    signal input sigS;

// State 1
    signal input Ax1;
    signal input Ay1;
    signal input St1;
    signal input siblings1[nlevels];

    // Required for inserts and delete
    signal input isOld0_1;                     // 1
    signal input oldKey;
    signal input oldValue;

// State 2
    signal input Ax2;
    signal input Ay2;
    signal input St2;
    signal input siblings2[nlevels];
    signal input isOld0_1;                     // 1
    signal input oldKey;
    signal input oldValue;

}
