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

include "montgomery.circom";
include "babyjub.circom";
include "comparators.circom";
Edwards2Montgomery
BitElementMulAny
Montgomery2Edwards
BabyAdd
Multiplexor2

// p is montgomery point
// n must be <= 248
// returns out in twisted edwards
// Double is in montgomery to be linked;

template SegmentMulAny(n) {
    signal input e[n];
    signal input p[2];
    signal output out[2];
    signal output dbl[2];

    component bits[n-1];

    component e2m = Edwards2Montgomery();

    p[0] ==> e2m.in[0];
    p[1] ==> e2m.in[1];

    var i;

    bits[0] = BitElementMulAny();
    e2m.out[0] ==> bits[0].dblIn[0]
    e2m.out[1] ==> bits[0].dblIn[1]
    e2m.out[0] ==> bits[0].addIn[0]
    e2m.out[1] ==> bits[0].addIn[1]
    e[1] ==> bits[0].sel;

    for (i=1; i<n-1; i++) {
        bits[i] = BitElementMulAny();

        bits[i-1].dblOut[0] ==> bits[i].dblIn[0]
        bits[i-1].dblOut[1] ==> bits[i].dblIn[1]
        bits[i-1].addOut[0] ==> bits[i].addIn[0]
        bits[i-1].addOut[1] ==> bits[i].addIn[1]
        e[i+1] ==> bits[i].sel;
    }

    bits[n-2].dblOut[0] ==> dbl[0];
    bits[n-2].dblOut[1] ==> dbl[1];

    component m2e = Montgomery2Edwards();

    bits[n-2].addOut[0] ==> m2e.in[0];
    bits[n-2].addOut[1] ==> m2e.in[1];

    component eadder = BabyAdd();

    m2e.out[0] ==> eadder.x1;
    m2e.out[1] ==> eadder.y1;
    -p[0] ==> eadder.x2;
    p[1] ==> eadder.y2;

    component lastSel = Multiplexor2();

    e[0] ==> lastSel.sel;
    eadder.xout ==> lastSel.in[0][0];
    eadder.yout ==> lastSel.in[0][1];
    m2e.out[0] ==> lastSel.in[1][0];
    m2e.out[1] ==> lastSel.in[1][1];

    lastSel.out[0] ==> out[0];
    lastSel.out[1] ==> out[1];
}