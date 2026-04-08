/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/

/*

SMTVerifier is a component to verify inclusion/exclusion of an element in the tree


fnc:  0 -> VERIFY INCLUSION
      1 -> VERIFY NOT INCLUSION

 */
 pragma circom 2.1.9;

include "smtbuses.circom";
include "../gates.circom";
include "../bitify.circom";
include "../comparators.circom";
include "../switcher.circom";
include "smtlevins.circom";
include "smtverifierlevel.circom";
include "smtverifiersm.circom";
include "smthash_poseidon.circom";

template SMTVerifier(nLevels) {
    input signal {binary} enabled;
    input signal root;
    input signal siblings[nLevels];
    input signal oldKey;
    input signal oldValue;
    input signal {binary} isOld0;
    input signal key;
    input signal value;
    input signal {binary} fnc;

    var i;

    component hash1Old = SMTHash1();
    hash1Old.key <== oldKey;
    hash1Old.value <== oldValue;

    component hash1New = SMTHash1();
    hash1New.key <== key;
    hash1New.value <== value;

    component n2bOld = Num2Bits_strict();
    component n2bNew = Num2Bits_strict();

    n2bOld.in <== oldKey;
    n2bNew.in <== key;

    component smtLevIns = SMTLevIns(nLevels);
    for (i=0; i<nLevels; i++) smtLevIns.siblings[i] <== siblings[i];
    smtLevIns.enabled <== enabled;

    component sm[nLevels];
    for (i=0; i<nLevels; i++) {
        sm[i] = SMTVerifierSM();
        if (i==0) {
            sm[i].prev.top <== enabled;
            sm[i].prev.i0 <== 0;
            sm[i].prev.inew <== 0;
            sm[i].prev.iold <== 0;
            sm[i].prev.na <== 1-enabled;
        } else {
            sm[i].prev <== sm[i-1].st;
        }
        sm[i].is0 <== isOld0;
        sm[i].fnc <== fnc;
        sm[i].levIns <== smtLevIns.levIns[i];
    }
    sm[nLevels-1].st.na + sm[nLevels-1].st.iold + sm[nLevels-1].st.inew + sm[nLevels-1].st.i0 === 1;

    component levels[nLevels];
    for (i=nLevels-1; i != -1; i--) {
        levels[i] = SMTVerifierLevel();

        levels[i].st <== sm[i].st;

        levels[i].sibling <== siblings[i];
        levels[i].old1leaf <== hash1Old.out;
        levels[i].new1leaf <== hash1New.out;

        levels[i].lrbit <== n2bNew.out[i];
        if (i==nLevels-1) {
            levels[i].child <== 0;
        } else {
            levels[i].child <== levels[i+1].root;
        }
    }


    // Check that if checking for non inclussuin and isOld0==0 then key!=old
    component areKeyEquals = IsEqual();
    areKeyEquals.in[0] <== oldKey;
    areKeyEquals.in[1] <== key;

    signal {binary} keys_1 <== 1-isOld0;
    component keysOk = MultiAND(4);
    keysOk.in[0] <== fnc;
    keysOk.in[1] <== keys_1;
    keysOk.in[2] <== areKeyEquals.out;
    keysOk.in[3] <== enabled;

    keysOk.out === 0;

    // Check the root
    component checkRoot = ForceEqualIfEnabled();
    checkRoot.enabled <== enabled;
    checkRoot.in[0] <== levels[0].root;
    checkRoot.in[1] <== root;

    // levels[0].root === root;

}
