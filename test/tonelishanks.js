const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");

const compiler = require("circom");

const assert = chai.assert;

describe("Square root test", () => {
    it("Should create a square root circuit", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "tonelishanks_test.circom"));
        assert.equal(cirDef.nVars, 3);

        const circuit = new snarkjs.Circuit(cirDef);
        const in_data = snarkjs.bigInt(4);
        const witness = circuit.calculateWitness({ "in": in_data });

        assert(witness[1].mul(witness[1]).equals(in_data));

    });
});
