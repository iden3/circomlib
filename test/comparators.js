const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const crypto = require("crypto");

const compiler = require("circom");

const assert = chai.assert;

describe("Sum test", () => {
    it("Should create a iszero circuit", async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "iszero.circom"));

        const circuit = new snarkjs.Circuit(cirDef);

        let witness;
        witness = circuit.calculateWitness({ "in": 111});
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in": 0 });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(1)));
    });
    it("Should create a isequal circuit", async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "isequal.circom"));

        const circuit = new snarkjs.Circuit(cirDef);

        let witness;
        witness = circuit.calculateWitness({ "in[0]": "111", "in[1]": "222" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in[0]": "444", "in[1]": "444" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(1)));
    });
    it("Should create a comparison", async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "lessthan.circom"));

        const circuit = new snarkjs.Circuit(cirDef);

        let witness;
        witness = circuit.calculateWitness({ "in[0]": "333", "in[1]": "444" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(1)));

        witness = circuit.calculateWitness({ "in[0]": "1", "in[1]": "1" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in[0]": "661", "in[1]": "660" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in[0]": "0", "in[1]": "1" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(1)));

        witness = circuit.calculateWitness({ "in[0]": "0", "in[1]": "444" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(1)));

        witness = circuit.calculateWitness({ "in[0]": "1", "in[1]": "0" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in[0]": "555", "in[1]": "0" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));

        witness = circuit.calculateWitness({ "in[0]": "0", "in[1]": "0" });
        assert(witness[0].equals(snarkjs.bigInt(1)));
        assert(witness[1].equals(snarkjs.bigInt(0)));
    });
});
