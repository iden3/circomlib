//DONE
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

include "bitify.circom";
include "escalarmulfix.circom";

/*
   only valid for bn128
   P = 21888242871839275222246405745257275088548364400416034343698204186575808495617
   check -1 === 21888242871839275222246405745257275088548364400416034343698204186575808495616
*/

template BabyAdd() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal output xout;
    signal output yout;

    // prime check
    -1 === 21888242871839275222246405745257275088548364400416034343698204186575808495616;

    signal beta;
    signal gamma;
    signal delta;
    signal tau;

    var a = 168700;
    var d = 168696;

    beta <== x1*y2;
    gamma <== y1*x2;
    delta <== (-a*x1+y1)*(x2 + y2);
    tau <== beta * gamma;

    xout <-- (beta + gamma) / (1+ d*tau);
    (1+ d*tau) * xout === (beta + gamma);

    yout <-- (delta + a*beta - gamma) / (1-d*tau);
    (1-d*tau)*yout === (delta + a*beta - gamma);
}

template BabyDbl() {
    signal input x;
    signal input y;
    signal output xout;
    signal output yout;

    // prime check
    -1 === 21888242871839275222246405745257275088548364400416034343698204186575808495616;
    
    BabyAdd()(x,y,x,y) ==> (xout, yout);
}


template BabyCheck() {
    signal input x;
    signal input y;

    // prime check
    -1 === 21888242871839275222246405745257275088548364400416034343698204186575808495616;
    
    signal x2;
    signal y2;

    var a = 168700;
    var d = 168696;

    x2 <== x*x;
    y2 <== y*y;

    a*x2 + y2 === 1 + d*x2*y2;
}

// Extracts the public key from private key
template BabyPbk() {
    signal input  in;
    signal output Ax;
    signal output Ay;

    // prime check
    -1 === 21888242871839275222246405745257275088548364400416034343698204186575808495616;
    
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    var aux[2] = EscalarMulFix(253, BASE8)(Num2Bits(253)(in));
    Ax <== aux[0];
    Ay <== aux[1];
}
