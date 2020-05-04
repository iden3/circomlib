/*
const chai = require("chai");
const path = require("path");
const crypto = require("crypto");

const assert = chai.assert;

const sha256 = require("../js/sha256");

const tester = require("circom").tester;

// const printSignal = require("../js/print_signal");

function buffer2bitArray(b) {
    const res = [];
    for (let i=0; i<b.length; i++) {
        for (let j=0; j<8; j++) {
            res.push((b[i] >> (7-j) &1));
        }
    }
    return res;
}

function bitArray2buffer(a) {
    const len = Math.floor((a.length -1 )/8)+1;
    const b = new Buffer.alloc(len);

    for (let i=0; i<a.length; i++) {
        const p = Math.floor(i/8);
        b[p] = b[p] | (Number(a[i]) << ( 7 - (i%8)  ));
    }
    return b;
}


describe("SHA256 test", function () {
    this.timeout(100000);

    it("Should work bits to array and array to bits", async () => {
        const b = new Buffer.alloc(64);
        for (let i=0; i<64; i++) {
            b[i] = i+1;
        }
        const a = buffer2bitArray(b);
        const b2 = bitArray2buffer(a);

        assert.equal(b.toString("hex"), b2.toString("hex"), true);
    });

    it("Should calculate a hash of 2 compressor", async () => {
        const cir = await tester(path.join(__dirname, "sha256_test512.test.circom"));

        const b = new Buffer.alloc(64);
        for (let i=0; i<64; i++) {
            b[i] = i+1;
        }

        const hash = crypto.createHash("sha256")
            .update(b)
            .digest("hex");

        const arrIn = buffer2bitArray(b);
        const witness = await cir.calculateWitness({ "in": arrIn }, true);

        const arrOut = witness.slice(1, 257);
        const hash2 = bitArray2buffer(arrOut).toString("hex");

        assert.equal(hash, hash2);

    }).timeout(1000000);
    it ("Should calculate a hash of 2 compressor", async () => {
        const cir = await tester(path.join(__dirname, "sha256_test448.test.circom"));

        const testStr = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";

        const b = Buffer.from(testStr, "utf8");

        const hash = crypto.createHash("sha256")
            .update(b)
            .digest("hex");

        const arrIn = buffer2bitArray(b);

        const witness = await cir.calculateWitness({ "in": arrIn }, true);

        const arrOut = witness.slice(1, 257);
        const hash2 = bitArray2buffer(arrOut).toString("hex");

        assert.equal(hash, hash2);
    });

});
*/