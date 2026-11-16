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
pragma circom 2.1.5;

include "bitify.circom";
include "montgomery.circom";
include "escalarmul/escalarmulfix.circom";
include "comparators.circom";
include "buses.circom";

// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617.

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
    spec tag babyedwards: 168700*(p.x)^2 + (p.y)^2 = 1 + 168696*(p.x)^2*(p.y)^2
    spec tag babymontgomery: (p.y)^2 = (p.x)^3 + 168698*(p.x)^2 + p.x
*/

/*
*** BabyAdd(): template that receives two points of the Baby-Jubjub curve in twisted Edwards form and returns the addition of the points.
        - Inputs: p1 = (x1, y1) -> bus representing a point of the curve in twisted Edwards form
                  p2 = (x2, y2) -> bus representing a point of the curve in twisted Edwards form
        - Outputs: pout = (xout, yout) -> bus representing a point of the curve in twisted Edwards form, pout = p1 + p2

    Twisted Edwards Addition Law:
                                               x1*y2 + y1*x2         y1*y2 - a * x1*x2
    [xout, yout] = [x1, y1] + [x2, y2] = [ --------------------- , --------------------- ]
                                            1 + d * x1*x2*y1*y2     1 - d * x1*x2*y1*y2     

    On Baby-Jubjub a is a square and d is not, so by the Bernstein-Lange criterion this law
    is complete: neither denominator can vanish for points on the curve. The template is
    therefore correct for any two points, including equal ones and the identity, and needs
    no precondition from the caller. MontgomeryAdd in montgomery.circom is cheaper but
    incomplete, so it is the right choice only where the caller can guarantee that the two
    points differ in x.

    Inputs must be on the curve.
*/

template BabyAdd() {
    input Point {babyedwards} pin1,pin2;
    output Point {babyedwards} pout;
    
    signal beta;
    signal gamma;
    signal delta;
    signal tau;

    var a = 168700;
    var d = 168696;

    beta <== pin1.x*pin2.y;
    gamma <== pin1.y*pin2.x;
    delta <== (-a*pin1.x + pin1.y)*(pin2.x + pin2.y);
    tau <== beta * gamma;
    
    pout.x <-- (beta + gamma) / (1 + d*tau);
    (1 + d*tau) * pout.x === (beta + gamma);

    pout.y <-- (delta + a*beta - gamma) / (1 - d*tau);
    (1 - d*tau)*pout.y === (delta + a*beta - gamma);
}



/*
*** BabyDouble(): template that receives a point pin of the Baby-Jubjub curve in twisted Edwards form and returns the point 2 * pin.
        - Inputs: pin = (x1, y1) -> bus representing a point of the curve in twisted Edwards form
        - Outputs: pout = (x2, y2) -> bus representing a point of the curve in twisted Edwards form, 2 * pin = pout
         
    Twisted Edwards Doubling Law: 2 * [x, y] = [x, y] + [x, y]
    Via BabyAdd (the addition law is complete).
    
*/

template BabyDbl() {
    input Point {babyedwards} pin;
    output Point {babyedwards} pout;
    component adder = BabyAdd();

    adder.pin1 <== pin;
    adder.pin2 <== pin;
    pout <== adder.pout;
}


/*
*** BabyCheck(): template that receives an input point pin and checks if it belongs to the Baby-Jubjub curve in twisted Edwards form.
        - Inputs: pin = (x1, y1) -> bus representing the point that we want to check
        - Outputs: pout = (x2, y2) -> two field values representing the same point as the input but with the babyedwards tag
                                      attached to point out it is a point of the Baby-Jubjub curve in twisted Edwards form
        
    The set of solutions of BabyCheck()(p) are the points of the Baby-Jubjub curve in twisted Edwards form.
    They must fulfil the equation a*x^2 + y^2 = 1 + d*x^2*y^2, a = 168700, d = 168696.
    
*/


template BabyCheck() {
    input Point pin;
    output Point {babyedwards} pout;

    // Point p2;
    signal x2;
    signal y2;

    var a = 168700;
    var d = 168696;

    x2 <== pin.x*pin.x; //x2 = pin.x^2
    y2 <== pin.y*pin.y; //y2 = pin.y^2
    
    a*x2 + y2 === 1 + d*x2*y2;
    
    pout <== pin; 
}


/*
*** BabyPbk(): template that receives an input in representing a value in the prime subgroup with order
               r = 2736030358979909402780800718157159386076813972158567259200215660948447373041,
               and returns the point of the Baby-Jubjub curve in twisted Edwards form in * P, with P being the point
               P = (5299619240641551281634865583518297030282874472190772894086521144482721001553, 16950150798460657717958625567821834550301663161624707787222815936182638968203)

This template is used to extract the public key from the private key.
        - Inputs: in -> field value in [1,r-1]
        - Outputs: A = (x, y) -> two field values representing a point of the curve in Edwards form, in * P = A
    
*/

template BabyPbk() {
    input signal {minvalue, maxvalue} in;
    output Point {babyedwards} A;


    var r = 2736030358979909402780800718157159386076813972158567259200215660948447373041;
    assert(in.minvalue > 0 && in.maxvalue < r);
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    component pvkBits = Num2Bits(253);
    pvkBits.in <== in;

    component mulFix = EscalarMulFix(253, BASE8);

    mulFix.e <== pvkBits.out;
    A <== mulFix.pout;
}

template NonZeroXCheck() {
  input Point {babyedwards} in;
  output Point {nonzerox,babyedwards} out;

  signal isz <== IsZero()(in.x);
  isz === 0;
  out <== in;
}
