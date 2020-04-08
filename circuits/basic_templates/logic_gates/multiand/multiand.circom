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

/* TODO: Simplify this function!

    De fet, només cal multiplicar-los tots. 
    Tot i que va millor així perquè es pot fer en 
    paral·lel, si és multiplicant és seqüencial.

    L'actual tempalte té (n-1) constraints, però 
    hi ha una manera de fer-lo sempre amb únicament
    3 constraints -> Com fer-lo: sum(s_i)_{i=1}^{n} = n.

*/

/*
    template MultiAND(n) {
        signal input in[n];
        signal output out;

        var sum = 0;

        for(var i=0; i<n; i++) {
            sum = sum + in[i];
        }

        sum - n === 0; //iszero aquí!

        // falta el tema out
    }
*/

// Multior?? -> El mateix, però la suma ha de ser diferent de 0.

/* Alternatively, it can be done like this (exemple de template 
    generada recursivament).
    Deixar aquest com a exemple de multiand fet recursivament, 
    però implementar l'altre.
*/

/*
    Implementar la MultiXOR(n) -> només un nombre parell 
    d'uns. Si hi ha un nombre parell -> 0, i si hi ha un 
    nombre senar -> 1.
*/