const chai = require("chai");
const snarkjs = require("snarkjs");
const mimcjs = require("../src/mimc7.js");
const expect = chai.expect;
const bigInt = snarkjs.bigInt;

function bytesToHex(buff) {
    return `0x${buff.toString("hex")}`;
}

function bigIntToBuffer(number) {
    const buff = Buffer.alloc(32);
    let pos = buff.length - 1;
    while (!number.isZero()) {
        buff[pos] = number.and(255);
        number = number.shiftRight(8);
        pos -= 1;
    }
    return buff;
}

describe("[mimc hash] Javascript test", function () {
  
    this.timeout(100000);
    before( async () => {
    });

    it("Mimc7 hash with 1 entry", () => {
        const entries = [bigInt(12)];
        const hash = mimcjs.multiHash(entries);
        const hashHex = bytesToHex(bigIntToBuffer(hash));
        expect(hashHex).to.be.equal("0x237c92644dbddb86d8a259e0e923aaab65a93f1ec5758b8799988894ac0958fd");
    });

    it("Mimc7 hash with 2 entries", () => {
        const entries = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)];
        const hi = mimcjs.multiHash(entries.slice(2));
        const hiHex = bytesToHex(bigIntToBuffer(hi));
        expect(hiHex).to.be.equal("0x067f3202335ea256ae6e6aadcd2d5f7f4b06a00b2d1e0de903980d5ab552dc70");
        const hv = mimcjs.multiHash(entries.slice(0, 2));
        const hvHex = bytesToHex(bigIntToBuffer(hv));
        expect(hvHex).to.be.equal("0x15ff7fe9793346a17c3150804bcb36d161c8662b110c50f55ccb7113948d8879");
    });

    it("Mimc7 hash with 4 entries", () => {
        const entries = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)];
        const hash = mimcjs.multiHash(entries);
        const hashHex = bytesToHex(bigIntToBuffer(hash));
        expect(hashHex).to.be.equal("0x284bc1f34f335933a23a433b6ff3ee179d682cd5e5e2fcdd2d964afa85104beb");
    });
});