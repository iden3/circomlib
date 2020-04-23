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

include "../mimc7/mimc7.circom"

template MultiMiMC7(nInputs, nRounds) {
    signal input in[nInputs];
    signal input k;
    signal output out;
    signal r[nInputs +1];

    component mims[nInputs];

    r[0] <== k;
    for (var i=0; i<nInputs; i++) {
        mims[i] = MiMC7(nRounds);
        mims[i].x_in <== in[i];
        mims[i].k <== r[i];
        r[i+1] <== r[i] + in[i] + mims[i].out;
    }

    out <== r[nInputs];
}
