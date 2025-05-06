const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

function generateBitArrays(n, array = [], index = 0, results = []) {
    if (index === n) {
        results.push([...array]);
        return results;
    }

    array[index] = 0;
    generateBitArrays(n, array, index + 1, results);

    array[index] = 1;
    generateBitArrays(n, array, index + 1, results);

    return results;
}


describe("Gates test", function ()  {

    this.timeout(100000);

    it("Should create a xor circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "xor.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "a": 1, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 1, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));
    });

    it("Should create a and circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "and.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "a": 1, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 1, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));
    });

    it("Should create a or circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "or.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "a": 1, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 1, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));
    });

    it("Should create a not circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "not.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));
    });

    it("Should create a nand circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "nand.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "a": 1, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 1, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));
    });

    it("Should create a nor circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "nor.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "a": 1, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 1, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 1 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "a": 0, "b": 0 }, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));
    });

    it("Should create a multiand circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "multiand.circom"));

        let witness;
        for(const array of generateBitArrays(3)) {
            witness = await circuit.calculateWitness({ "in": array }, true);
            const and = array.reduce((a, b) => !!a && !!b)
            assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
            assert(Fr.eq(Fr.e(witness[1]), Fr.e(and)));
        }
    });
});
