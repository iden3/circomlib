const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("Binary sum test", function () {

    this.timeout(100000000);

    it("Should create a constant circuit", async () => {
        const circuit = await tester(path.join(__dirname, "circuits", "constants_test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nWires, 2);

        const witness = await circuit.calculateWitness({ "in": bigInt("d807aa98", 16)});

        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt("d807aa98", 16)));
    });
    it("Should create a sum circuit", async () => {
        const circuit = await tester(path.join(__dirname, "circuits", "sum_test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nWires, 97);  // 32 (in1) + 32(in2) + 32(out) + 1 (carry)

        const witness = await circuit.calculateWitness({ "a": "111", "b": "222" });

        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt("333")));
    });
});
