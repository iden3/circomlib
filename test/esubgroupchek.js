const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");

const compiler = require("circom");
const babyJub = require("../src/babyjub.js");

const assert = chai.assert;

describe("Subgroup decompress test", () => {
    it("Should find y component for base8", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "esubgroupcheck_test.circom"));

        const circuit = new snarkjs.Circuit(cirDef);

        const witness = circuit.calculateWitness({ "x": c.Base8[0].value});
        assert(witness[1].equals(c.Base8[1].value));

    });
});
