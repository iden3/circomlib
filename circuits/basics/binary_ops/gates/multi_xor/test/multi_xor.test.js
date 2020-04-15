const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("MultiXOR test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "multixor_test.circom"));
    });

    it("Even amount of 1s outputs FALSE", async () => {
        const witness = await circuit.calculateWitness({"in": [1,1,0,0,0]}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Odd amount of 1s outputs TRUE", async () => {
        const witness = await circuit.calculateWitness({"in": [0,1,1,0,1]}, true);
        await circuit.assertOut(witness, {out: 1});
    });
});
