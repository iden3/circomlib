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

include "../../../../montgomery/montgomeryadd/montgomeryadd.circom";
include "../../../../montgomery/montgomerydouble/montgomerydouble.circom";
include "../../../../edwards2montgomery/edwards2montgomery.circom";
include "../../../../montgomery2edwards/montgomery2edwards.circom";
include "../../../babyadd/babyadd.circom";
include "../windowmulfix/windowmulfix.circom";

/*
    This component does a multiplication of a escalar times a fix base
    Signals:
        e: The scalar in bits
        base: the base point in edwards format
        out:  The result
        dbl: Point in Edwards to be linked to the next segment.
 */

template SegmentMulFix(nWindows) {
    signal input e[nWindows*3];
    signal input base[2];
    signal output out[2];
    signal output dbl[2];

    var i;
    var j;

    // Convert the base to montgomery

    component e2m = Edwards2Montgomery();
    e2m.in[0] <== base[0];
    e2m.in[1] <== base[1];

    component windows[nWindows];
    component adders[nWindows];
    component cadders[nWindows];

    // In the last step we add an extra doubler so that numbers do not match.
    component dblLast = MontgomeryDouble();

    for (i=0; i<nWindows; i++) {
        windows[i] = WindowMulFix();
        cadders[i] = MontgomeryAdd();
        if (i==0) {
            windows[i].base[0] <== e2m.out[0];
            windows[i].base[1] <== e2m.out[1];
            cadders[i].in1[0] <== e2m.out[0];
            cadders[i].in1[1] <== e2m.out[1];
        } else {
            windows[i].base[0] <== windows[i-1].out8[0];
            windows[i].base[1] <== windows[i-1].out8[1];
            cadders[i].in1[0] <== cadders[i-1].out[0];
            cadders[i].in1[1] <== cadders[i-1].out[1];
        }
        for (j=0; j<3; j++) {
            windows[i].in[j] <== e[3*i+j];
        }
        if (i<nWindows-1) {
            cadders[i].in2[0] <== windows[i].out8[0];
            cadders[i].in2[1] <== windows[i].out8[1];
        } else {
            dblLast.in[0] <== windows[i].out8[0];
            dblLast.in[1] <== windows[i].out8[1];
            cadders[i].in2[0] <== dblLast.out[0];
            cadders[i].in2[1] <== dblLast.out[1];
        }
    }

    for (i=0; i<nWindows; i++) {
        adders[i] = MontgomeryAdd();
        if (i==0) {
            adders[i].in1[0] <== dblLast.out[0];
            adders[i].in1[1] <== dblLast.out[1];
        } else {
            adders[i].in1[0] <== adders[i-1].out[0];
            adders[i].in1[1] <== adders[i-1].out[1];
        }
        adders[i].in2[0] <== windows[i].out[0];
        adders[i].in2[1] <== windows[i].out[1];
    }

    component m2e = Montgomery2Edwards();
    component cm2e = Montgomery2Edwards();

    m2e.in[0] <== adders[nWindows-1].out[0];
    m2e.in[1] <== adders[nWindows-1].out[1];
    cm2e.in[0] <== cadders[nWindows-1].out[0];
    cm2e.in[1] <== cadders[nWindows-1].out[1];

    component cAdd = BabyAdd();
    cAdd.x1 <== m2e.out[0];
    cAdd.y1 <== m2e.out[1];
    cAdd.x2 <== -cm2e.out[0];
    cAdd.y2 <== cm2e.out[1];

    cAdd.xout ==> out[0];
    cAdd.yout ==> out[1];

    windows[nWindows-1].out8[0] ==> dbl[0];
    windows[nWindows-1].out8[1] ==> dbl[1];
}