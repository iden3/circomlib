// Copyright (c) 2018 Jordi Baylina
// License: LGPL-3.0+
//

const Contract = require("./evmasm");
const { unstringifyBigInts } = require("ffjavascript").utils;

const { C:K, M } = unstringifyBigInts(require("./poseidon_constants.json"));

const N_ROUNDS_F = 8;
const N_ROUNDS_P = [56, 57, 56, 60, 60, 63, 64, 63];

function toHex256(a) {
    let S = a.toString(16);
    while (S.length < 64) S="0"+S;
    return "0x" + S;
}

function createCode(nInputs) {

    if (( nInputs<1) || (nInputs>8)) throw new Error("Invalid number of inputs. Must be 1<=nInputs<=8");
    const t = nInputs + 1;
    const nRoundsF = N_ROUNDS_F;
    const nRoundsP = N_ROUNDS_P[t - 2];

    const C = new Contract();

    function saveM() {
        for (let i=0; i<t; i++) {
            for (let j=0; j<t; j++) {
                C.push(toHex256(M[t-2][j][i]));
                C.push((1+i*t+j)*32);
                C.mstore();
            }
        }
    }

    function ark(r) {   // st, q
        for (let i=0; i<t; i++) {
            C.dup(t); // q, st, q
            C.push(toHex256(K[t-2][r*t+i]));  // K, q, st, q
            C.dup(2+i); // st[i], K, q, st, q
            C.addmod(); // newSt[i], st, q
            C.swap(1 + i); // xx, st, q
            C.pop();
        }
    }

    function sigma(p) {
        // sq, q
        C.dup(t);   // q, st, q
        C.dup(1+p); // st[p] , q , st, q
        C.dup(1);   // q, st[p] , q , st, q
        C.dup(0);   // q, q, st[p] , q , st, q
        C.dup(2);   // st[p] , q, q, st[p] , q , st, q
        C.dup(0);   // st[p] , st[p] , q, q, st[p] , q , st, q
        C.mulmod(); // st2[p], q, st[p] , q , st, q
        C.dup(0);   // st2[p], st2[p], q, st[p] , q , st, q
        C.mulmod(); // st4[p], st[p] , q , st, q
        C.mulmod(); // st5[p], st, q
        C.swap(1+p);
        C.pop();      // newst, q
    }

    function mix() {
        C.label("mix");
        for (let i=0; i<t; i++) {
            for (let j=0; j<t; j++) {
                if (j==0) {
                    C.dup(i+t);      // q, newSt, oldSt, q
                    C.push((1+i*t+j)*32);
                    C.mload();      // M, q, newSt, oldSt, q
                    C.dup(2+i+j);    // oldSt[j], M, q, newSt, oldSt, q
                    C.mulmod();      // acc, newSt, oldSt, q
                } else {
                    C.dup(1+i+t);    // q, acc, newSt, oldSt, q
                    C.push((1+i*t+j)*32);
                    C.mload();      // M, q, acc, newSt, oldSt, q
                    C.dup(3+i+j);    // oldSt[j], M, q, acc, newSt, oldSt, q
                    C.mulmod();      // aux, acc, newSt, oldSt, q
                    C.dup(2+i+t);    // q, aux, acc, newSt, oldSt, q
                    C.swap(2);       // acc, aux, q, newSt, oldSt, q
                    C.addmod();      // acc, newSt, oldSt, q
                }
            }
        }
        for (let i=0; i<t; i++) {
            C.swap((t -i) + (t -i-1));
            C.pop();
        }
        C.push(0);
        C.mload();
        C.jmp();
    }


    // Check selector
    C.push("0x0100000000000000000000000000000000000000000000000000000000");
    C.push(0);
    C.calldataload();
    C.div();
    C.push("0xc4420fb4"); // poseidon(uint256[])
    C.eq();
    C.jmpi("start");
    C.invalid();

    C.label("start");

    saveM();

    C.push("0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001");  // q

    // Load t values from the call data.
    // The function has a single array param param
    // [Selector (4)] [Pointer (32)][Length (32)] [data1 (32)] ....
    // We ignore the pointer and the length and just load t values to the state
    // (Stack positions 0-{t-1}) If the array is shorter, we just set zeros.
    for (let i=0; i<t; i++) {
        C.push(0x44+(0x20*(t-1-i)));
        C.calldataload();
    }

    for (let i=0; i<nRoundsF+nRoundsP-1; i++) {
        ark(i);
        if ((i<nRoundsF/2) || (i>=nRoundsP+nRoundsF/2)) {
            for (let j=0; j<t; j++) {
                sigma(j);
            }
        } else {
            sigma(0);
        }
        const strLabel = "aferMix"+i;
        C._pushLabel(strLabel);
        C.push(0);
        C.mstore();
        C.jmp("mix");
        C.label(strLabel);
    }

    C.push(toHex256(K[t-2][(nRoundsF+nRoundsP-1)*t]));  // K, st, q
    C.dup(t+1); // q, K, st, q
    C.swap(2);  // st[0], K, q, st\st[0]
    C.addmod();  // st q

    sigma(0);

    C.push("0x00");
    C.mstore();     // Save it to pos 0;
    C.push("0x20");
    C.push("0x00");
    C.return();

    mix();

    return C.createTxData();
}

module.exports.abi = [
    {
        "constant": true,
        "inputs": [
            {
                "name": "input",
                "type": "uint256[]"
            }
        ],
        "name": "poseidon",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "pure",
        "type": "function"
    }
];

module.exports.createCode = createCode;


