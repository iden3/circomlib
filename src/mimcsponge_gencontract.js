// Copyright (c) 2018 Jordi Baylina
// License: LGPL-3.0+
//

const Web3Utils = require("web3-utils");

const Contract = require("./evmasm");

function createCode(seed, n) {

    let ci = Web3Utils.keccak256(seed);

    const C = new Contract();

    C.push(0x64);
    C.push("0x00");
    C.push("0x00");
    C.calldatacopy();
    C.push("0x0100000000000000000000000000000000000000000000000000000000");
    C.push("0x00");
    C.mload();
    C.div();
    C.push("0xf47d33b5"); // MiMCSponge(uint256,uint256)
    C.eq();
    C.jmpi("start");
    C.invalid();

    C.label("start");
    C.push("0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001");  // q
    C.push("0x04");
    C.mload();          // xL q
    C.dup(1);           // q xL q
    C.push("0x24");
    C.mload();          // xR q xL q
    C.dup(1);           // q xR q xL q
    C.dup(3);           // xL q xR q xL q
    C.dup(1);           // q xL q xR q xL q
    C.dup(0);           // q q xL q xR q xL q
    C.dup(2);           // xL q q xL q xR q xL q
    C.dup(0);           // xL xL q q xL q xR q xL q
    C.mulmod();         // b=xL^2 q xL q xR q xL q
    C.dup(0);           // b b q xL q xR q xL q
    C.mulmod();         // c=xL^4 xL q xR q xL q
    C.mulmod();         // d=xL^5 xR q xL q
    C.addmod();         // e=xL^5+xR xL q (for next round: xL xR q)

    for (let i=0; i<n-1; i++) {
        if (i < n-2) {
          ci = Web3Utils.keccak256(ci);
        } else {
          ci = "0x00";
        }
        C.swap(1);      // xR xL q
        C.dup(2);       // q xR xL q
        C.dup(2);       // xL q xR xL q
        C.push(ci);     // ci xL q xR xL q
        C.addmod();     // a=ci+xL xR xL q
        C.dup(3);       // q a xR xL q
        C.swap(1);      // a q xR xL q
        C.dup(1);       // q a q xR xL q
        C.dup(0);       // q q a q xR xL q
        C.dup(2);       // a q q a q xR xL q
        C.dup(0);       // a a q q a q xR xL q
        C.mulmod();     // b=a^2 q a q xR xL q
        C.dup(0);       // b b q a q xR xL q
        C.mulmod();     // c=a^4 a q xR xL q
        C.mulmod();     // d=a^5 xR xL q
        C.dup(3);       // q d xR xL q
        C.swap(2);      // xR d q xL q
        C.addmod();     // e=a^5+xR xL q (for next round: xL xR q)
    }

    C.push("0x20");
    C.mstore();     // Save it to pos 0;
    C.push("0x00");
    C.mstore();     // Save it to pos 1;
    C.push("0x40");
    C.push("0x00");
    C.return();

    return C.createTxData();
}

module.exports.abi = [
    {
        "constant": true,
        "inputs": [
            {
                "name": "xL_in",
                "type": "uint256"
            },
            {
                "name": "xR_in",
                "type": "uint256"
            }
        ],
        "name": "MiMCSponge",
        "outputs": [
            {
                "name": "xL",
                "type": "uint256"
            },
            {
                "name": "xR",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "pure",
        "type": "function"
    }
];

module.exports.createCode = createCode;


