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

include "../montgomery.circom";
include "../babyjub.circom";
include "../comparators.circom";
include "../buses.circom";

// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617.


/*

*** Multiplexor2(): template that implements a multiplexer 2-to-1 between two inputs of 2 elements
    - If s == 0 then out = in[0]
    - If s == 1 then out = in[1]

        - Inputs: sel -> binary value, selector
                       requires tag binary
                  in[2][2] -> two arrays of 2 elements that correspond to the inputs of the mux: in[0] => first input, in[1] => second input 
        - Output: out[2] -> array of 2 elements, it takes the value in[0] if sel == 0, in[1] if sel == 1 

 */

template MultiplexorEdwards2() {
    input signal {binary} sel;
    input Point {babyedwards} pin[2];
    output Point {babyedwards} pout;

    pout.x <== (pin[1].x - pin[0].x)*sel + pin[0].x;
    pout.y <== (pin[1].y - pin[0].y)*sel + pin[0].y;
}

template MultiplexorMontgomery2() {
    input signal {binary} sel;
    input Point {babymontgomery} pin[2];
    output Point {babymontgomery} pout;

    pout.x <== (pin[1].x - pin[0].x)*sel + pin[0].x;
    pout.y <== (pin[1].y - pin[0].y)*sel + pin[0].y;
}


/*

*** BitElementMulAny(): template that receives three inputs: sel representing a bit, and two points of the elliptic curve in Montgomery form dblIn and addIn, and returns the points in Montgomery form dblOut and addOut according to the scheme below. This circuit is used in order to multiply a point of the BabyJub curve by a escalar (k * p with p in the curve). 
        - Inputs: sel -> binary value
                         requires tag binary
                  dblIn[2] -> input curve point in Montgomery representation
                  addIn[2] -> input curve point in Montgomery representation
        - Outputs: dblOut[2] -> output curve point in Montgomery representation
                   addOut[2] -> output curve point in Montgomery representation


*** dblOut = 2 * dblIn;
*** addOut = 
          -- If sel == 0: addIn;
          -- If sel == 1: 2 * dblIn + addIn;

*/

template BitElementMulAny() {
    input signal {binary} sel;
    input Point {babymontgomery} dblIn;
    input Point {babymontgomery} addIn;
    output Point {babymontgomery} dblOut;
    output Point {babymontgomery} addOut;

    component doubler = MontgomeryDouble();
    component adder = MontgomeryAdd();
    component selector = MultiplexorMontgomery2();


    sel ==> selector.sel;

    dblIn ==> doubler.pin;
    doubler.pout ==> adder.pin1;
    addIn ==> adder.pin2;
    addIn ==> selector.pin[0];
    adder.pout ==> selector.pin[1];


    doubler.pout ==> dblOut;
    selector.pout ==> addOut;

}

/*

*** SegmentMulAny(n): template that receives two inputs p[2] and e[n] representing a point of BabyJub curve in its Edwards representation and the binary representation of a field value k respectively, and returns the value out according to the scheme below. This circuit is used in order to multiply a point of the BabyJub curve by a escalar (k * p with p in the curve). 
        - Inputs: e[n] -> binary representation of k
                           requires tag binary
                  p[2] -> input curve point in Edwards representation
        - Outputs: out[2] -> output curve point in Edwards representation

TODO: ADD SCHEME

*/

template SegmentMulAny(n) {
    input signal {binary}  e[n];
    input Point {babyedwards} pin;
    output Point {babyedwards} pout;
    output Point {babymontgomery} dbl;

    component bits[n-1];

    component e2m = Edwards2Montgomery();

    pin ==> e2m.pin;

    var i;

    bits[0] = BitElementMulAny();
    e2m.pout ==> bits[0].dblIn;
    e2m.pout ==> bits[0].addIn;
    e[1] ==> bits[0].sel;

    for (i=1; i<n-1; i++) {
        bits[i] = BitElementMulAny();

        bits[i-1].dblOut ==> bits[i].dblIn;
        bits[i-1].addOut ==> bits[i].addIn;
        e[i+1] ==> bits[i].sel;
    }

    bits[n-2].dblOut ==> dbl;

    component m2e = Montgomery2Edwards();

    bits[n-2].addOut ==> m2e.pin;

    component eadder = BabyAdd();

    m2e.pout ==> eadder.pin1;
    Point {babyedwards} inv_pin;
    inv_pin.x <== -pin.x;
    inv_pin.y <== pin.y;
    inv_pin ==> eadder.pin2;

    component lastSel = MultiplexorEdwards2();

    e[0] ==> lastSel.sel;
    eadder.pout ==> lastSel.pin[0];
    m2e.pout ==> lastSel.pin[1];

    lastSel.pout ==> pout;
}

/*

*** EscalarMulAny(n): template that receives two inputs p[2] and e[n] representing a point of BabyJub curve in its Edwards representation and the binary representation of a field value k respectively, and returns the value out according to the scheme below. This circuit is used in order to multiply a point of the BabyJub curve by a escalar (k * p with p in the curve). The input e is the binary representation of the value k and p is the point of the curve.
        - Inputs: e[n] -> binary representation of k
                           requires tag binary
                  p[2] -> input curve point to be multiplied in Edwards representation
        - Outputs: out[2] -> output curve point k * p in Edwards representation

     Note: This function assumes that p is in the subgroup and it is different to 0

TODO: ADD SCHEME

*/

template EscalarMulAny(n) {
    input signal {binary} e[n];              // Input in binary format
    input Point {babyedwards} pin;              // Point (Twisted format)
    output Point {babyedwards} pout;           // Point (Twisted format)

    var nsegments = (n-1)\148 +1;
    var nlastsegment = n - (nsegments-1)*148;

    component segments[nsegments];
    component doublers[nsegments-1];
    component m2e[nsegments-1];
    component adders[nsegments-1];
    component zeropoint = IsZero();
    zeropoint.in <== pin.x;

    var s;
    var i;
    var nseg;
    
    Point {babyedwards} aux;

    for (s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? 148 : nlastsegment;

        segments[s] = SegmentMulAny(nseg);

        for (i=0; i<nseg; i++) {
            e[s*148+i] ==> segments[s].e[i];
        }

        if (s==0) {
            // force G8 point if input point is zero
            aux.x <== pin.x + (5299619240641551281634865583518297030282874472190772894086521144482721001553 - pin.x)*zeropoint.out;
            aux.y <== pin.y + (16950150798460657717958625567821834550301663161624707787222815936182638968203 - pin.y)*zeropoint.out;
            segments[s].pin <== aux;
        } else {
            doublers[s-1] = MontgomeryDouble();
            m2e[s-1] = Montgomery2Edwards();
            adders[s-1] = BabyAdd();

            segments[s-1].dbl ==> doublers[s-1].pin;
            doublers[s-1].pout ==> m2e[s-1].pin;
            m2e[s-1].pout ==> segments[s].pin;

            if (s==1) {
                segments[s-1].pout ==> adders[s-1].pin1;
            } else {
                adders[s-2].pout ==> adders[s-1].pin1;
            }
            segments[s].pout ==> adders[s-1].pin2;
        }
    }

    if (nsegments == 1) {
        segments[0].pout.x*(1-zeropoint.out) ==> pout.x;
        segments[0].pout.y+(1-segments[0].pout.y)*zeropoint.out ==> pout.y;
    } else {
        adders[nsegments-2].pout.x*(1-zeropoint.out) ==> pout.x;
        adders[nsegments-2].pout.y+(1-adders[nsegments-2].pout.y)*zeropoint.out ==> pout.y;
    }
}
