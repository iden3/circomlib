

/******

SMTInsertLevel

This circuit has 2 has

Outputs according to the state.

State        oldRoot                    newRoot
=====        =======                    =======
top          H'(oldChild, sibling)       H'(newChild, sibling)
old1         old1leaf                    H'(newChild, 0)
old0         0                           new1leaf
bot          0                           H'(newChild, 0)
new1         0                           H'(new1leaf, old1leaf)
na           0                           0

H' is the Hash function with the inputs shifted acordingly.

*****/


template SMTInsertLevel() {
    signal input st_top;
    signal input st_old1;
    signal input st_old0;
    signal input st_bot;
    signal input st_new1;
    signal input st_na;

    signal output oldRoot;
    signal output newRoot;
    signal input sibling;
    signal input old1leaf;
    signal input new1leaf;
    signal input newlrbit;
    signal input oldChild;
    signal input newChild;

    signal aux[4];

    component oldProofHash = SMTHash2();
    component newProofHash = SMTHash2();

    component oldSwitcher = Switcher();
    component newSwitcher = Switcher();

    // Old side

    oldSwitcher.L <== oldChild;
    oldSwitcher.R <== sibling;

    oldSwitcher.sel <== newlrbit;
    oldProofHash.L <== oldSwitcher.outL;
    oldProofHash.R <== oldSwitcher.outR;

    aux[0] <== old1leaf * st_old1;
    oldRoot <== aux[0] +  oldProofHash.out * st_top;

    // New side

    aux[1] <== newChild * ( st_top + st_old1 + st_bot);
    newSwitcher.L <== aux[1] + new1leaf*st_new1;

    aux[2] <== sibling*st_top;
    newSwitcher.R <== aux[2] + old1leaf*st_new1;

    newSwitcher.sel <== newlrbit;
    newProofHash.L <== newSwitcher.outL;
    newProofHash.R <== newSwitcher.outR;

    aux[3] <== newProofHash.out * (st_top + st_old1 + st_bot + st_new1);
    newRoot <==  aux[3] + new1leaf * st_old0;
}
