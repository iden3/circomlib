const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("Is Zero test", function ()  {

    this.timeout(100000);

    it("Should create a iszero circuit", async() => {
        const circuit = await tester(path.join(__dirname, "iszero_test.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": 111}, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(0)));

        witness = await circuit.calculateWitness({ "in": 0 }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));
    });
});
