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
        expect(hashHex).to.be.equal("0x04252a243a23848a29fa5783336905f6394585fb38d0d89f16d36084c53cb73c");
    });

    it("Mimc7 hash with 2 entries", () => {
        const entries = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)];
        const hi = mimcjs.multiHash(entries.slice(2));
        const hiHex = bytesToHex(bigIntToBuffer(hi));
        expect(hiHex).to.be.equal("0x1fd4bc970a697084ec1f83ecf81936d4a047e27c654752ddbc89f9ed1728e0ab");
        const hv = mimcjs.multiHash(entries.slice(0, 2));
        const hvHex = bytesToHex(bigIntToBuffer(hv));
        expect(hvHex).to.be.equal("0x263924eb9ae730cea9ce31bb9ada695ec3525536b4c058813552b074db36ba9a");
    });

    it("Mimc7 hash with 4 entries", () => {
        const entries = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)];
        const hash = mimcjs.multiHash(entries);
        const hashHex = bytesToHex(bigIntToBuffer(hash));
        expect(hashHex).to.be.equal("0x10e02cc6c8fc40cda121602903df911f6398d65f84ff1f27c680d0b7d85b7418");
    });
});