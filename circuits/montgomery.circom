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

/*
    Baby Jubjub in Montgomery form:

        B*v^2 = u^3 + A*u^2 + u,  with A = 2*(a + d)/(a - d) = 168698, B = 4/(a - d) = 1

    Montgomery addition and doubling are cheaper than the Edwards ones in
    babyjub.circom (3-4 constraints instead of 6), but they are NOT complete:
    the identity cannot be represented, and the formulas fail for P1 = +-P2.
    Callers must rule these cases out.

    Edwards points are (x, y) and Montgomery points are (u, v).
*/

/*
    (u, v) = ((1 + y)/(1 - y), u/x)
    Undefined for x = 0 or y = 1, which includes the identity (0, 1).
*/
template Edwards2Montgomery() {
    signal input in[2];
    signal output out[2];

    out[0] <-- (1 + in[1]) / (1 - in[1]);
    out[1] <-- out[0] / in[0];

    out[0] * (1 - in[1]) === 1 + in[1];
    out[1] * in[0] === out[0];
}

/*
    (x, y) = (u/v, (u - 1)/(u + 1))
    Undefined for v = 0 or u = -1.
*/
template Montgomery2Edwards() {
    signal input in[2];
    signal output out[2];

    out[0] <-- in[0] / in[1];
    out[1] <-- (in[0] - 1) / (in[0] + 1);

    out[0] * in[1] === in[0];
    out[1] * (in[0] + 1) === in[0] - 1;
}

/*
    out = in1 + in2:
        lambda = (v2 - v1) / (u2 - u1)
        u3 = B*lambda^2 - A - u1 - u2
        v3 = lambda*(u1 - u3) - v1
    Requires u1 != u2, i.e. in1 != +-in2. If in1 = in2, the lambda constraint
    becomes 0 === 0 and the output is unconstrained.
*/
template MontgomeryAdd() {
    signal input in1[2];
    signal input in2[2];
    signal output out[2];

    var a = babyjub_a();
    var d = babyjub_d();

    var A = 2*(a + d) / (a - d);
    var B = 4 / (a - d);

    signal lamda;

    lamda <-- (in2[1] - in1[1]) / (in2[0] - in1[0]);
    lamda * (in2[0] - in1[0]) === in2[1] - in1[1];

    out[0] <== B*lamda*lamda - A - in1[0] - in2[0];
    out[1] <== lamda * (in1[0] - out[0]) - in1[1];
}

/*
    out = 2*in:
        lambda = (3*u1^2 + 2*A*u1 + 1) / (2*B*v1)
        u3 = B*lambda^2 - A - 2*u1
        v3 = lambda*(u1 - u3) - v1
    Requires v1 != 0 (in is not a point of order 2).
*/
template MontgomeryDouble() {
    signal input in[2];
    signal output out[2];

    var a = babyjub_a();
    var d = babyjub_d();

    var A = 2*(a + d) / (a - d);
    var B = 4 / (a - d);

    signal lamda;
    signal x1_2;

    x1_2 <== in[0]*in[0];

    lamda <-- (3*x1_2 + 2*A*in[0] + 1) / (2*B*in[1]);
    lamda * (2*B*in[1]) === 3*x1_2 + 2*A*in[0] + 1;

    out[0] <== B*lamda*lamda - A - 2*in[0];
    out[1] <== lamda * (in[0] - out[0]) - in[1];
}
