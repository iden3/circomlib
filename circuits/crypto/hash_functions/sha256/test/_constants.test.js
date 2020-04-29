const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("Constants test", function () {

    this.timeout(100000000);

    it("Should create a constant circuit", async () => {
        const circuit = await tester(path.join(__dirname, "_constants.test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nVars, 2);
        assert.equal(circuit.constraints.length, 1);

        const witness = await circuit.calculateWitness({ "in": bigInt("d807aa98", 16)}, true);

        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt("d807aa98", 16)));
    });
});
