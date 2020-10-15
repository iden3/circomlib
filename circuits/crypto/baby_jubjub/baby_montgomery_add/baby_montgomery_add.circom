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
             x2 - x1
    lambda = ---------
             y2 - y1

                                                       x3 + A + x1 + x2
    x3 = B * lambda^2 - A - x1 -x2    =>  lambda^2 = ------------------
                                                              B

    y3 = (2*x1 + x2 + A)*lambda - B*lambda^3 - y1  =>


    =>  y3 = lambda * ( 2*x1 + x2 + A  - x3 - A - x1 - x2)  - y1 =>

    =>  y3 = lamda * ( x1 - x3 ) - y1

----------

             y2 - y1
    lambda = ---------
             x2 - x1

    x3 = B * lambda^2 - A - x1 -x2

    y3 = lambda * ( x1 - x3 ) - y1

 */

template BabyMontgomeryAdd() {
    signal input in1[2];
    signal input in2[2];
    signal output out[2];

    var a = 168700;
    var d = 168696;

    var A = (2 * (a + d)) / (a - d);
    var B = 4 / (a - d);

    signal lambda;

    lambda <-- (in2[1] - in1[1]) / (in2[0] - in1[0]);
    lambda * (in2[0] - in1[0]) === (in2[1] - in1[1]);

    out[0] <== B*lambda*lambda - A - in1[0] -in2[0];
    out[1] <== lambda * (in1[0] - out[0]) - in1[1];
}