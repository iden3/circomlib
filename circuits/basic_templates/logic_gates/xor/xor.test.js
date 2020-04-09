const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("XOR test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "xor_test.circom"));
    });

    it("1 XOR 1 = 0", async () => {
        const witness = await circuit.calculateWitness({ "a": "1", "b": "1" }, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("1 XOR 0 = 1", async () => {
        const witness = await circuit.calculateWitness({ "a": "1", "b": "0" }, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("0 XOR 1 = 1", async () => {
        const witness = await circuit.calculateWitness({ "a": "0", "b": "1" }, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("0 XOR 0 = 0", async () => {
        const witness = await circuit.calculateWitness({ "a": "0", "b": "0" }, true);
        await circuit.assertOut(witness, {out: 0});
    });

});
