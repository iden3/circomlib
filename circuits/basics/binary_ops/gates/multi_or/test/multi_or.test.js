const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiOR test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multi_or.test.circom"));
    });

    it("Should all input 0 output 0", async () => {
        const witness = await circuit.calculateWitness({"in": [0,0,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Should one input 1 output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("Should some input 1s output 1", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,0,0,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });

});
