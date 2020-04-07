const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const bigInt = require("big-integer");

const assert = chai.assert;

describe("Comparators: -Greater or equal than- test", function ()  {

    this.timeout(100000);passing

    it("Should create a comparison greatereqthan", async() => {
        const circuit = await tester(path.join(__dirname, "greatereqthan.circom"));
        passing
        let witness;
        witness = await circuit.calculateWitness({ "in": [333,444] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(0)));

        witness = await circuit.calculateWitness({ "in":[1,1] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));

        witness = await circuit.calculateWitness({ "in": [661, 660] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));

        witness = await circuit.calculateWitness({ "in": [0, 1] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(0)));

        witness = await circuit.calculateWitness({ "in": [0, 444] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(0)));

        witness = await circuit.calculateWitness({ "in": [1, 0] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));

        witness = await circuit.calculateWitness({ "in": [555, 0] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));

        witness = await circuit.calculateWitness({ "in": [0, 0] }, true);
        assert(witness[0].equals(bigInt(1)));
        assert(witness[1].equals(bigInt(1)));
    });
});
