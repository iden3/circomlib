const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiAND test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multi_and.test.circom"));
    });

    it("Should satisfy all inputs 1 output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [1,1,1,1,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("Should satisfy one input 0 output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [1,0,1,1,1]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Should satisfy some inputs 0s output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,1]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

});
