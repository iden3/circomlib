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

include "babyjub_params.circom";
include "bitify.circom";
include "escalarmulfix.circom";

/*
    Baby Jubjub elliptic curve
    ==========================

    Reference: EIP-2494 "Baby Jubjub Elliptic Curve"
               https://eips.ethereum.org/EIPS/eip-2494

    Baby Jubjub is a twisted Edwards curve defined over the scalar field F_r of
    BN254, the field circom works in by default. All curve arithmetic below is
    therefore native field arithmetic and needs no non-native emulation.

        r = 21888242871839275222246405745257275088548364400416034343698204186575808495617

    Twisted Edwards form:

        a*x^2 + y^2 = 1 + d*x^2*y^2,  with a = 168700, d = 168696

    Group structure:

        curve order  n = 8 * l
        cofactor     h = 8
        subgroup     l = 2736030358979909402780800718157159386076813972158567259200215660948447373041
                         (251-bit prime)

    Distinguished points:

        identity   O = (0, 1)
        negation   -(x, y) = (-x, y)
        generator  G = (995203441582195749578291179787384436505546430278305826713579947235728471134,
                        5472060717959818805561601436314318772137091100104008585924551046643952123905)
                   generates the full group of order n.
        base point B = 8*G
                     = (5299619240641551281634865583518297030282874472190772894086521144482721001553,
                        16950150798460657717958625567821834550301663161624707787222815936182638968203)
                   generates the prime-order subgroup of order l.
*/

/*
    (xout, yout) = (x1, y1) + (x2, y2), using the addition law:
        x3 = (x1*y2 + y1*x2) / (1 + d*x1*x2*y1*y2)
        y3 = (y1*y2 - a*x1*x2) / (1 - d*x1*x2*y1*y2)
    Complete (also valid for doubling and the identity).
    Inputs must be on the curve.
*/
template BabyAdd() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal output xout;
    signal output yout;

    signal beta;
    signal gamma;
    signal delta;
    signal tau;

    var a = babyjub_a();
    var d = babyjub_d();

    beta <== x1*y2;
    gamma <== y1*x2;
    delta <== (-a*x1 + y1) * (x2 + y2);
    tau <== beta*gamma;

    xout <-- (beta + gamma) / (1 + d*tau);
    (1 + d*tau) * xout === (beta + gamma);

    yout <-- (delta + a*beta - gamma) / (1 - d*tau);
    (1 - d*tau) * yout === (delta + a*beta - gamma);
}

// (xout, yout) = 2*(x, y), via BabyAdd (the addition law is complete).
template BabyDbl() {
    signal input x;
    signal input y;
    signal output xout;
    signal output yout;

    component adder = BabyAdd();
    adder.x1 <== x;
    adder.y1 <== y;
    adder.x2 <== x;
    adder.y2 <== y;

    xout <== adder.xout;
    yout <== adder.yout;
}

// Asserts that (x, y) is on the curve.
template BabyCheck() {
    signal input x;
    signal input y;

    signal x2;
    signal y2;

    var a = babyjub_a();
    var d = babyjub_d();

    x2 <== x*x;
    y2 <== y*y;

    a*x2 + y2 === 1 + d*x2*y2;
}

/*
    (Ax, Ay) = in * B, where B = 8*G is the base point.
    `in` is the secret scalar and must be < 2^253.
*/
template BabyPbk() {
    signal input in;
    signal output Ax;
    signal output Ay;

    var BASE8[2] = babyjub_base8();

    component pvkBits = Num2Bits(253);
    pvkBits.in <== in;

    component mulFix = EscalarMulFix(253, BASE8);

    for (var i = 0; i < 253; i++) {
        mulFix.e[i] <== pvkBits.out[i];
    }

    Ax <== mulFix.out[0];
    Ay <== mulFix.out[1];
}
