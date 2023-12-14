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

// The templates and functions in this file are general and work for any prime field


/*

*** Switcher(): template that receives three inputs: L, R and sel with sel being a binary value, and switchs the value of L and R in case sel == 1, that it returns the values outL and outR such that:
    - If sel == 0 then outL = L and outR=R
    - If sel == 1 then outL = R and outR=L

        - Inputs: sel -> binary value
                         requires tag binary
                  L -> field element
                  R -> field element
        - Output: outL -> field element, if sel == 0 then L, else R
                  outR -> field element, if sel == 0 then R, else L
         
    Example: Switcher()(1, 4, 7) = (7, 4)

 */

template Switcher() {
    signal input {binary} sel;
    signal input L;
    signal input R;
    signal output outL;
    signal output outR;

    signal aux;

    aux <== (R-L)*sel;    // We create aux in order to have only one multiplication
    outL <==  aux + L;
    outR <== -aux + R;
}
