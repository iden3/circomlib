const chai = require("chai");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe.only("Array test", function ()  {

    this.timeout(100000);

    it("Should create a sum circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "array_sum_test.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [7, 3, 6, 4]}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(20)));

        witness = await circuit.calculateWitness({ "in": [2, 1, 5, 4]}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(12)));
    });

    it("Should create a contains circuit", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "array_contains_test.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [7, 3, 6, 4], "value": 3}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [7, 3, 7, 4], "value": 7}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [7, 3, 6, 4], "value": 5}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [7, 5, 6, 4], "value": 3}, true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));
    });
});
