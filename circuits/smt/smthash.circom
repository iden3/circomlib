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

include "../mimc.circom";


/*
    Hash1 = H(1 | key | value)
 */

template SMTHash1() {
    signal input key;
    signal input value;
    signal output out;

    component h1 = MiMC7(91);   // Constant
    h1.x_in <== 15021630795539610737508582392395901278341266317943626182700664337106830745361;
    h1.k <== 1;

    component h2 = MiMC7(91);
    h2.x_in <== h1.out;
    h2.k <== key;

    component h3 = MiMC7(91);
    h3.x_in <== h2.out;
    h3.k <== value;

    out <== h3.out;
}

/*
    This component is used to create the 2 nodes.

    Hash2 = H(Hl | Hr)
 */

template SMTHash2() {
    signal input L;
    signal input R;
    signal output out;

    component h1 = MiMC7(91);
    h1.x_in <== 15021630795539610737508582392395901278341266317943626182700664337106830745361;
    h1.k <== L;

    component h2 = MiMC7(91);
    h2.x_in <== h1.out;
    h2.k <== R;

    out <== h2.out;
}
