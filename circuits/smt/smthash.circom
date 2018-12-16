include "../mimc.circom";


/*
    Hash1 = H(1 | key | value)
 */

template SMTHash1() {
    signal input key;
    signal input value;
    signal output out;

    component h1 = MiMC7(91);   // Constant
    h1.x_in <== 15021630795539610737508582392395901278341266317943626182700664337106830745361;
    h1.k <== 1;

    component h2 = MiMC7(91);
    h2.x_in <== h1.out;
    h2.k <== key;

    component h3 = MiMC7(91);
    h3.x_in <== h2.out;
    h3.k <== value;

    out <== h3.out;
}

/*
    This component is used to create the 2 nodes.

    Hash2 = H(Hl | Hr)
 */

template SMTHash2() {
    signal input L;
    signal input R;
    signal output out;

    component h1 = MiMC7(91);
    h1.x_in <== 15021630795539610737508582392395901278341266317943626182700664337106830745361;
    h1.k <== L;

    component h2 = MiMC7(91);
    h2.x_in <== h1.out;
    h2.k <== R;

    out <== h2.out;
}
