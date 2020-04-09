const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("NOT test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "not_test.circom"));
    });

    it("NOT 1 = 0", async () => {
        const witness = await circuit.calculateWitness({ "in": "1"}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("NOT 0 = 1", async () => {
        const witness = await circuit.calculateWitness({ "in": "0"}, true);
        await circuit.assertOut(witness, {out: 1});
    });

});
