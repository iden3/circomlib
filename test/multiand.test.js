const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiAND test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multiand_test.circom"));
    });

    it("All 1 output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [1,1,1,1,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("One 0 output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [1,0,1,1,1]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Some 0s output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,1]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

});
