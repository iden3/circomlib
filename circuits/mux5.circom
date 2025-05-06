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
pragma circom 2.0.0;

include "mux2.circom";
include "mux3.circom";

template MultiMux5(n) {
    signal input c[n][32];  // Constants
    signal input s[5];   // Selector
    signal output out[n];

    component leafs[n][8];
    component root[n];
    for (var i=0; i<n; i++) {
        // Make a tree (with depth 2).  Leaf nodes are Mux3 components (with 4 leaf node) and one Mux2 root node.

        // Leaf components
        for (var j=0; j<4; j++) {
            leafs[i][j] = Mux3();

            // Set the leaf component's constants
            for (var k=0; k<8; k++) {
                leafs[i][j].c[k] <== c[i][8 * j + k];
            }

            // Set the leaf component's selector (the least significant 3 bits of the selector);
            leafs[i][j].s[0] <== s[0];
            leafs[i][j].s[1] <== s[1];
            leafs[i][j].s[2] <== s[2];
        }

        // Root component
        root[i] = Mux2();

        // Set the root component's constants (the output of it's child nodes).
        for (var j=0; j<4; j++) {
            root[i].c[j] <== leafs[i][j].out;
        }

        // Set the root component's selector (the most significant 2 bits of the selector);
        root[i].s[0] <== s[3];
        root[i].s[1] <== s[4];

        out[i] <== root[i].out;
    }
}

template Mux5() {
    var i;
    signal input c[32];  // Constants
    signal input s[5];   // Selector
    signal output out;

    component mux = MultiMux5(1);

    for (i=0; i<32; i++) {
        mux.c[0][i] <== c[i];
    }

    for (i=0; i<5; i++) {
      s[i] ==> mux.s[i];
    }

    mux.out[0] ==> out;
}
