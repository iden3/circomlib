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
 
include "buses.circom";
 
// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617. 

/*
    Source: https://en.wikipedia.org/wiki/Montgomery_curve

*/

/*
    The Baby-Jubjub Montgomery elliptic curve defined over the finite field bn128 is given by the equation

    B*v^2 = u^3 + A*u^2 + u, A = 168698, B = 1

    This curve is birationally equivalent to the twisted Edwards elliptic curve

    a*x^2 + y^2 = 1 + d*x^2*y^2, a = 168700 = (A+2)/B, d = 168696 = (A-2)/B

                                    u     u-1                                     1+y       1+y
    via the map (u,v) -> (x,y) = [ --- , ----- ] with inverse (x,y) -> (u,v) = [ ----- , --------- ]
                                    v     u+1                                     1-y     (1-y)*x

    Since a is a square in bn128, the twisted Edwards curve is isomorphic to the Edwards curve
    
    x'^2 + y'^2 = 1 + d'*x'^2*y'^2

    via the map (x,y) -> (x',y') = [ sqrt(a)*x , y ]

    where d' = 9706598848417545097372247223557719406784115219466060233080913168975159366771.
    Here circuits are provided to transform a point of the Baby-Jubjub curve in twisted Edwards to its Montgomery form and vice versa.
    Circuits to add and double points of the Baby-Jubjub Montgomery curve are provided as well.
*/

/*
    spec tag babyedwards: 168700*(p.x)^2 + (p.y)^2 = 1 + 168696*(p.x)^2*(p.y)^2
    spec tag babymontgomery: (p.y)^2 = (p.x)^3 + 168698*(p.x)^2 + p.x
*/

/*
*** Edwards2Montgomery(): template that receives a point of the Baby-Jubjub curve in twisted Edwards form
                          and returns the equivalent point in Montgomery form.
        - Inputs: pin -> bus representing a point of the Baby-Jubjub curve in twisted Edwards form
        - Outputs: pout -> bus representing a point of the Baby-Jubjub curve in Montgomery form
         
    Map from twisted Edwards elliptic curve to its birationally equivalent Montgomery curve:
    
                          1 + y        1 + y
    (x, y) -> (u, v) = [ -------  , ----------- ]
                          1 - y      (1 - y)*x
    
*/

template Edwards2Montgomery() {
    input Point {babyedwards} pin;
    output Point {babymontgomery} pout;

    // pin.x must be non-zero, otherwise pout.y * pin.x === pout.x says nothing about
    // pout.y and leaves it free. Supplying an inverse is satisfiable exactly when
    // pin.x != 0, and costs one constraint.
    signal xInv;
    xInv <-- 1 / pin.x;
    xInv * pin.x === 1;

    pout.x <-- (1 + pin.y) / (1 - pin.y);
    pout.y <-- pout.x / pin.x;

    pout.x * (1 - pin.y) === (1 + pin.y);
    pout.y * pin.x === pout.x;
}

/*
*** Montgomery2Edwards(): template that receives an input pin representing a point of the Baby-Jubjub curve in Montgomery form
                          and returns the equivalent point in twisted Edwards form.
        - Inputs: pin -> bus representing a point of the Baby-Jubjub curve in Montgomery form
        - Outputs: pout -> bus representing a point of the curve Baby-Jubjub in twisted Edwards form
         
    Map from Montgomery elliptic curve to its birationally equivalent twisted Edwards curve:
    
                          u    u - 1
    (u, v) -> (x, y) = [ ---, ------- ]
                          v    u + 1

 */

template Montgomery2Edwards() {
    input Point {babymontgomery} pin;
    output Point {babyedwards} pout;

    // pin.y must be non-zero, otherwise pout.x * pin.y === pin.x says nothing about
    // pout.x and leaves it free.
    signal yInv;
    yInv <-- 1 / pin.y;
    yInv * pin.y === 1;

    pout.x <-- pin.x / pin.y;
    pout.y <-- (pin.x - 1) / (pin.x + 1);

    pout.x * pin.y === pin.x;
    pout.y * (pin.x + 1) === pin.x - 1;
}


/*
*** DistinctXCheck(): template that receives two points of the Baby-Jubjub curve in Montgomery form, constrains them
                      to differ in x, and returns the second one carrying the xdistinct tag.
        - Inputs: pin1 -> bus representing a point of the Baby-Jubjub curve in Montgomery form
                  pin2 -> bus representing a point of the Baby-Jubjub curve in Montgomery form
        - Outputs: out -> the same point as pin2, tagged xdistinct
                          the tag records that out.x != pin1.x for the pin1 it was checked against

    Costs one constraint: an inverse of pin2.x - pin1.x is supplied as a witness, which is
    satisfiable exactly when the difference is non-zero.
*/

template DistinctXCheck() {
    input Point {babymontgomery} pin1;
    input Point {babymontgomery} pin2;
    output Point {babymontgomery, xdistinct} out;

    signal dxInv;
    dxInv <-- 1 / (pin2.x - pin1.x);
    dxInv * (pin2.x - pin1.x) === 1;

    out <== pin2;
}

/*
*** AssumeDistinctX(): template that grants the xdistinct tag without adding any constraint.
        - Inputs: pin2 -> bus representing a point of the Baby-Jubjub curve in Montgomery form
        - Outputs: out -> the same point, tagged xdistinct

    Zero constraints. This is a statement by the caller, not a check: the compiler will
    accept it whether or not the point really differs in x from what it will be added to.
    Use it only where the surrounding algorithm proves the property, and write that proof
    next to the call. Every call to this template is a soundness assumption that a review
    must be able to find and verify; that is what the tag is for.
*/

template AssumeDistinctX() {
    input Point {babymontgomery} pin2;
    output Point {babymontgomery, xdistinct} out;

    out <== pin2;
}

/*
*** MontgomeryAdd(): template that receives two inputs pin1, pin2 representing points of the Baby-Jubjub curve in Montgomery form
                     and returns the addition of the points.
        - Inputs: pin1 -> bus representing a point of the Baby-Jubjub curve in Montgomery form
                  pin2 -> bus representing a point of the Baby-Jubjub curve in Montgomery form
                          requires tag xdistinct: pin2.x != pin1.x
        - Outputs: pout -> bus representing the point pin1 + pin2 of the Baby-Jubjub curve in Montgomery form

    This addition law is incomplete: it is defined only when the two points differ in x.
    If they do not, the constraint on lamda degenerates to 0 === 0 and lamda, and with it
    the output, is left free. The xdistinct tag on pin2 makes the caller say how that is
    ruled out, and the compiler rejects a call that does not:
      - DistinctXCheck()(pin1, pin2)  -> one constraint, holds for any inputs
      - AssumeDistinctX()(pin2)       -> no constraint; the caller's algorithm is the proof
    Which template to reach for:
      - the points are known to be equal      -> MontgomeryDouble()
      - the points are known to differ in x   -> MontgomeryAdd() with AssumeDistinctX()
      - neither is known                      -> MontgomeryAdd() with DistinctXCheck(),
                                                 or BabyAdd() in babyjub.circom
    BabyAdd works on the twisted Edwards form, and its law is complete on Baby-Jubjub, so
    it is correct for every pair of points on the curve with no precondition to discharge.
    It is what BabyDbl uses to add a point to itself.
         
    Montgomery Addition Law:

                                            y2 - y1                        y2 - y1                           y2 - y1
    [x3, y3] = [x1, y1] + [x2, y2] = [ B*( --------- )^2 - A - x1 - x2, ( --------- )*(A + 2*x1 + x2) - B*( --------- )^3 - y1 ]
                                            x2 - x1                        x2 - x1                           x2 - x1

             y2 - y1
    lamda = ---------
             x2 - x1

    x3 = B*lamda^2 - A - x1 -x2

    y3 = lamda*( x1 - x3 ) - y1
*/

template MontgomeryAdd() {
    input Point {babymontgomery} pin1;
    input Point {babymontgomery, xdistinct} pin2;
    output Point {babymontgomery} pout;

    var A = 168698;
    var B = 1;

    signal lamda;

    // pin2 carries xdistinct, so pin2.x - pin1.x is non-zero and lamda is determined.
    lamda <-- (pin2.y - pin1.y) / (pin2.x - pin1.x);
    lamda * (pin2.x - pin1.x) === pin2.y - pin1.y;

    pout.x <== B*lamda*lamda - A - pin1.x - pin2.x;
    pout.y <== lamda * (pin1.x - pout.x) - pin1.y;
}

/*
*** MontgomeryDouble(): template that receives an input pin representing a point of the Baby-Jubjub curve in Montgomery form
                        and returns the point 2 * pin.
        - Inputs: pin -> bus representing a point of the Baby-Jubjub curve in Montgomery form
        - Outputs: pout -> bus representing the point 2*pin of the Baby-Jubjub curve in Montgomery form
         
         
    Montgomery Doubling Law:

                                   3*x1^2 + 2*A*x1 + 1                        3*x1^2 + 2*A*x1 + 1                           3*x1^2 + 2*A*x1 + 1
    [x2, y2] = 2*[x1, y1] = [ B*( --------------------- )^2 - A - x1 - x2, ( --------------------- )*(A + 2*x1 + x2) - B*( --------------------- )^3 - y1 ]
                                         2*B*y1                                     2*B*y1                                        2*B*y1

    x1_2 = x1*x1

             3*x1_2 + 2*A*x1 + 1
    lamda = ---------------------
                   2*B*y1

    x2 = B*lamda^2 - A - x1 -x1

    y2 = lamda*( x1 - x2 ) - y1

 */
 
template MontgomeryDouble() {
    input Point {babymontgomery} pin;
    output Point {babymontgomery} pout;

    var A = 168698;
    var B = 1;

    signal lamda;
    signal x1_2;

    x1_2 <== pin.x * pin.x;

    lamda <-- (3*x1_2 + 2*A*pin.x + 1) / (2*B*pin.y);
    lamda * (2*B*pin.y) === (3*x1_2 + 2*A*pin.x + 1);

    pout.x <== B*lamda*lamda - A - 2*pin.x;
    pout.y <== lamda * (pin.x - pout.x) - pin.y;
}



/*
*** MontgomeryBabyCheck(): template that receives an input point pin and checks that it
                           belongs to the Baby-Jubjub curve in Montgomery form.
        - Inputs: pin -> bus representing the point that we want to check
        - Outputs: pout -> the same point as the input, with the babymontgomery tag
                           attached to point out it is on the Baby-Jubjub Montgomery curve

    The set of solutions of MontgomeryBabyCheck()(p) are the points of the Baby-Jubjub
    curve in Montgomery form. They must fulfil the equation y^2 = x^3 + A*x^2 + x,
    A = 168698.

    This is the Montgomery counterpart of BabyCheck() in babyjub.circom, which does the
    same for the twisted Edwards form and grants the babyedwards tag instead.
*/

template MontgomeryBabyCheck(){
    input Point pin;
    output Point {babymontgomery} pout;
    
    var A = 168698;
    
    signal x_2 <== pin.x * pin.x;
    signal y_2 <== pin.y * pin.y;
    
    y_2 === x_2 * pin.x + A * x_2 + pin.x; 
    
    pin ==> pout;

}
