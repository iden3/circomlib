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
pragma circom 2.0.4;

include "../binsum.circom";
include "../bitify.circom";
include "../comparators.circom";

// The output is the signal in array at the position given by acces

template ArrayAccess(n) {

    signal input array[n];
    signal input {max} access;
    signal output value;

    assert(access.max < n);

    signal  access_pos[n];
    signal distance_pos[n];

    //component chkzero[n];
    
    for (var i = 0; i < n; i++) {
        access_pos[i] <== IsZero()(i-access);
	//chkzero[i] = IsZero();
	//chkzero[i].in <== i-access;
	//access_pos[i] <== chkzero[i].out;
    }

    signal access_value[n];

    for (var i = 0; i < n; i++) {
        access_value[i] <== access_pos[i] * array[i];
    }

    var valsum = 0;
    for (var i = 0; i < n; i++) {
        valsum += access_value[i];
    }
    
    value <== valsum;
}


