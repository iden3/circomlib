const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiXOR test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multi_xor.test.circom"));
    });

    it("Should output 0 if an even amount of inputs are 1", async () => {
        const witness = await circuit.calculateWitness({"in": [1,1,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Should output 1 if an odd amount of inputs are 1", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,1,0,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });
});
