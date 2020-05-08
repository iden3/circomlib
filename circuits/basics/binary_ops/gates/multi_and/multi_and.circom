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

include "../../../comparators/is_zero/is_zero.circom";

// Out true iff all of its operands are true.
template MultiAND(n) {
    signal input in[n];
    signal output out;
    var sum = 0;

    for(var i=0; i<n; i++) {
        sum = sum + in[i];
    }

    component isz = IsZero();

    sum - n ==> isz.in; 
    
    isz.out ==> out;
}

/*

ALTERNATIVELY, MultiAND can be implemented recursively:
(Although then it takes n-1 constraints)

-----

include "../and/and.circom";

template MultiAND(n) {
    signal input in[n];
    signal output out;
    var i;
    if (n==1) {
        out <== in[0];
    } else if (n==2) {
        component and1 = AND();
        and1.a <== in[0];
        and1.b <== in[1];
        out <== and1.out;
    } else {
        component and2 = AND();
        component ands[2];
        var n1 = n\2;
        var n2 = n-n\2;
        ands[0] = MultiAND(n1);
        ands[1] = MultiAND(n2);
        for (i=0; i<n1; i++) ands[0].in[i] <== in[i];
        for (i=0; i<n2; i++) ands[1].in[i] <== in[n1+i];
        and2.a <== ands[0].out;
        and2.b <== ands[1].out;
        out <== and2.out;
    }
}

*/