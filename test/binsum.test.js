const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("BinSum test", function () {

    this.timeout(100000000);

    it("Should create a binary sum circuit", async () => {
        const circuit = await tester(path.join(__dirname, "binsum_test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.constraints.length, 97);  // 32 (in1) + 32(in2) + 32(out) + 1 (carry)

        const witness = await circuit.calculateWitness({ "a": "111", "b": "222" }, true);

        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt("333")));
    });
});
