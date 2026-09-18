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

Defines a bus that represents a state of the state machine (sm) used to perform the smt hashing.
See smtverifiersm.circom to see more details of the behavior of this machine

*/
 pragma circom 2.1.9;


// Every field is a bit and exactly one of them is 1 at any level: the state is one hot.
// The level templates rely on both, multiplying by the fields as booleans.
bus SMTVerifierState() {
    signal {binary} top;
    signal {binary} i0;
    signal {binary} iold;
    signal {binary} inew;
    signal {binary} na;
}


// As above: one hot over six states.
bus SMTProcessorState() {
    signal {binary} top;
    signal {binary} old0;
    signal {binary} bot;
    signal {binary} new1;
    signal {binary} na;
    signal {binary} upd;
}

