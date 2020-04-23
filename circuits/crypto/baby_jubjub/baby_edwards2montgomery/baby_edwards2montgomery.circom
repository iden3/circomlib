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
    Source: https://en.wikipedia.org/wiki/Montgomery_curve

                1 + y       1 + y
    [u, v] = [ -------  , ---------- ]
                1 - y      (1 - y)x

 */

template BabyEdwards2Montgomery() {
    signal input in[2];
    signal output out[2];

    out[0] <-- (1 + in[1]) / (1 - in[1]);
    out[1] <-- out[0] / in[0];


    out[0] * (1-in[1]) === (1 + in[1]);
    out[1] * in[0] === out[0];
}