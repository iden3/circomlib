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

        const witness = circuit.calculateWitness({ "x": babyJub.Base8[0].value});
        assert(witness[1].equals(babyJub.Base8[1].value));

    });

    it("Should decompress base8 point", async () => {
        const p = babyJub.Base8;
        const decompressed = babyJub.subgroupDecompress(babyJub.Base8[0]);
        assert(decompressed[0].value == p[0].value && decompressed[1].value == p[1].value);

    });
});
