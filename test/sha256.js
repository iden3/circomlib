const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const crypto = require("crypto");

const compiler = require("circom");

const assert = chai.assert;

const sha256 = require("./helpers/sha256");

// const printSignal = require("./helpers/printsignal");


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


describe("SHA256 test", () => {


    it("Should work bits to array and array to bits", async () => {
        const b = new Buffer.alloc(64);
        for (let i=0; i<64; i++) {
            b[i] = i+1;
        }
        const a = buffer2bitArray(b);
        const b2 = bitArray2buffer(a);

        assert.equal(b.toString("hex"), b2.toString("hex"));
    });

    it("Should calculate a hash of 1 compressor", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "sha256_2_test.circom"));
        const circuit = new snarkjs.Circuit(cirDef);

        console.log("Vars: "+circuit.nVars);
        console.log("Constraints: "+circuit.nConstraints);

        const witness = circuit.calculateWitness({ "a": "1", "b": "2" });

        const b = new Buffer.alloc(54);
        b[26] = 1;
        b[53] = 2;

        const hash = crypto.createHash("sha256")
            .update(b)
            .digest("hex");
        const r = "0x" + hash.slice(10);

        const hash2 = sha256.hash(b.toString("hex"), {msgFormat: "hex-bytes"});

        assert.equal(hash, hash2);

        assert(witness[1].equals(snarkjs.bigInt(r)));
    }).timeout(1000000);

    it("Should calculate a hash of 2 compressor", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "sha256_test512.circom"),  {reduceConstraints:false}  );
        const circuit = new snarkjs.Circuit(cirDef);

        console.log("Vars: "+circuit.nVars);
        console.log("Constraints: "+circuit.nConstraints);

/*
        const testStr = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";

        const b = Buffer.from(testStr, 'utf8');
*/
        const b = new Buffer.alloc(64);
        for (let i=0; i<64; i++) {
            b[i] = i+1;
        }

        const hash = crypto.createHash("sha256")
            .update(b)
            .digest("hex");

        const arrIn = buffer2bitArray(b);
        const witness = circuit.calculateWitness({ "in": arrIn } /*, {logOutput: true} */);

        const arrOut = witness.slice(1, 257);
        const hash2 = bitArray2buffer(arrOut).toString("hex");

        assert.equal(hash, hash2);

    }).timeout(1000000);


    it("Should calculate a hash of 2 compressor", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "sha256_test448.circom"),  {reduceConstraints:false}  );
        const circuit = new snarkjs.Circuit(cirDef);

        console.log("Vars: "+circuit.nVars);
        console.log("Constraints: "+circuit.nConstraints);


        const testStr = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";

        const b = Buffer.from(testStr, 'utf8');
        for (let i=0; i<64; i++) {
            b[i] = i+1;
        }

        const hash = crypto.createHash("sha256")
            .update(b)
            .digest("hex");

        const arrIn = buffer2bitArray(b);
        const witness = circuit.calculateWitness({ "in": arrIn } /*, {logOutput: true} */);

        const arrOut = witness.slice(1, 257);
        const hash2 = bitArray2buffer(arrOut).toString("hex");

        assert.equal(hash, hash2);

    }).timeout(1000000);
});
