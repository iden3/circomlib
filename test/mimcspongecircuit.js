const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");
const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;

const w3utils = require("web3-utils");
const F = bn128.Fr;

const mimcjs = require("../src/mimcsponge.js");

const assert = chai.assert;

describe("MiMC Sponge Circuit test", function () {
    let circuit;

    this.timeout(100000);

    it("Should check permutation", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "mimc_sponge_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("MiMC Feistel constraints: " + circuit.nConstraints);

        const w = circuit.calculateWitness({xL_in: 1, xR_in: 2, k: 3});

        const xLout = w[circuit.getSignalIdx("main.xL_out")];
        const xRout = w[circuit.getSignalIdx("main.xR_out")];

        const out2 = mimcjs.hash(1,2,3);

        assert.equal(xLout.toString(), out2.xL.toString());
        assert.equal(xRout.toString(), out2.xR.toString());

        assert(circuit.checkWitness(w));

    });

    it("Should encrypt and decrypt a single message", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "mimc_sponge_decrypt_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("MiMC Feistel constraints: " + circuit.nConstraints);

        const w = circuit.calculateWitness({xL_in: 1, xR_in: 2, k: 3});

        const xLout = w[circuit.getSignalIdx("main.xL_out")];
        const xRout = w[circuit.getSignalIdx("main.xR_out")];

        assert.equal(xLout.toString(), 1 + "");
        assert.equal(xRout.toString(), 2 + "");

        assert(circuit.checkWitness(w));
    });

    it("Should fail to encrypt and decrypt a single message with different keys", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "mimc_sponge_decrypt_fail_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("MiMC Feistel constraints: " + circuit.nConstraints);

        const w = circuit.calculateWitness({xL_in: 1, xR_in: 2, k: 3, k_two: 4});

        const xLout = w[circuit.getSignalIdx("main.xL_out")];
        const xRout = w[circuit.getSignalIdx("main.xR_out")];

        assert.notEqual(xLout.toString(), 1 + "");
        assert.notEqual(xRout.toString(), 2 + "");

        assert(circuit.checkWitness(w));
    });

    it("Should check hash", async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "mimc_sponge_hash_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("MiMC Sponge constraints: " + circuit.nConstraints);

        const w = circuit.calculateWitness({ins: [1, 2], k: 0});

        const o1 = w[circuit.getSignalIdx("main.outs[0]")];
        const o2 = w[circuit.getSignalIdx("main.outs[1]")];
        const o3 = w[circuit.getSignalIdx("main.outs[2]")];

        const out2 = mimcjs.multiHash([1,2], 0, 3);

        assert.equal(o1.toString(), out2[0].toString());
        assert.equal(o2.toString(), out2[1].toString());
        assert.equal(o3.toString(), out2[2].toString());

        assert(circuit.checkWitness(w));

    });

});
