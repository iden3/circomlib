const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiOR test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multior_test.circom"));
    });

    it("All 0 output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [0,0,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("One 1 output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("Some 1s output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

});
