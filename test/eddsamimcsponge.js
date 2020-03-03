const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const eddsa = require("../src/eddsa.js");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;

describe("EdDSA MiMCSponge test", function () {
    let circuit;

    this.timeout(100000);

    before( async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "eddsamimcsponge_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains EdDSA MiMCSponge: " + circuit.nConstraints);
    });

    it("Sign a single number", async () => {
        const msg = bigInt(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        const signature = eddsa.signMiMCSponge(prvKey, msg);

        assert(eddsa.verifyMiMCSponge(msg, signature, pubKey));

        const w = circuit.calculateWitness({
            enabled: 1,
            Ax: pubKey[0],
            Ay: pubKey[1],
            R8x: signature.R8[0],
            R8y: signature.R8[1],
            S: signature.S,
            M: msg});

        assert(circuit.checkWitness(w));
    });

    it("Detect Invalid signature", async () => {
        const msg = bigInt(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signMiMCSponge(prvKey, msg);

        assert(eddsa.verifyMiMCSponge(msg, signature, pubKey));
        try {
            const w = circuit.calculateWitness({
                enabled: 1,
                Ax: pubKey[0],
                Ay: pubKey[1],
                R8x: signature.R8[0].add(bigInt(1)),
                R8y: signature.R8[1],
                S: signature.S,
                M: msg});
            assert(false);
        } catch(err) {
            assert(err.message.indexOf("Constraint doesn't match") >= 0);
            assert(err.message.indexOf("1 != 0") >= 0);
        }
    });


    it("Test a dissabled circuit with a bad signature", async () => {
        const msg = bigInt(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signMiMCSponge(prvKey, msg);

        assert(eddsa.verifyMiMCSponge(msg, signature, pubKey));

        const w = circuit.calculateWitness({
            enabled: 0,
            Ax: pubKey[0],
            Ay: pubKey[1],
            R8x: signature.R8[0].add(bigInt(1)),
            R8y: signature.R8[1],
            S: signature.S,
            M: msg});

        assert(circuit.checkWitness(w));
    });
});
