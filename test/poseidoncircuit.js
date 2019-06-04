const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const poseidon = require("../src/poseidon.js");

const assert = chai.assert;

describe("Poseidon Circuit test", function () {
    let circuit;

    this.timeout(100000);

    before( async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "poseidon_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("Poseidon constraints: " + circuit.nConstraints);
    });

    it("Should check constrain", async () => {
        const w = circuit.calculateWitness({inputs: [1, 2]});

        const res = w[circuit.getSignalIdx("main.out")];

        const hash = poseidon.createHash(6, 8, 57);

        const res2 = hash([1,2]);

        console.log(res.toString());

        assert.equal(res.toString(), res2.toString());

        assert(circuit.checkWitness(w));

    });
});
