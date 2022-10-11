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
pragma circom 2.0.8;

// states that if the input codition signal is 1 the outsignal is ifsignal otherwies it is elsesignal

template ConditionalConstraint() {

    signal input {binary} condition;
    signal input ifsignal;
    signal input elsesignal;
    signal output outsignal;

    outsignal <== (ifsignal - elsesignal) * condition + elsesignal;
}
