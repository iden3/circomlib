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

include "_multiplexor2.circom";
include "../baby_montgomery_add/baby_montgomery_add.circom";
include "../baby_montgomery_dbl/baby_montgomery_dbl.circom";

template BitElementMulAny() {
    signal input sel;
    signal input dblIn[2];
    signal input addIn[2];
    signal output dblOut[2];
    signal output addOut[2];

    component doubler = BabyMontgomeryDbl();
    component adder = BabyMontgomeryAdd();
    component selector = Multiplexor2();


    sel ==> selector.sel;

    dblIn[0] ==> doubler.in[0];
    dblIn[1] ==> doubler.in[1];
    doubler.out[0] ==> adder.in1[0];
    doubler.out[1] ==> adder.in1[1];
    addIn[0] ==> adder.in2[0];
    addIn[1] ==> adder.in2[1];
    addIn[0] ==> selector.in[0][0];
    addIn[1] ==> selector.in[0][1];
    adder.out[0] ==> selector.in[1][0];
    adder.out[1] ==> selector.in[1][1];

    doubler.out[0] ==> dblOut[0];
    doubler.out[1] ==> dblOut[1];
    selector.out[0] ==> addOut[0];
    selector.out[1] ==> addOut[1];
}