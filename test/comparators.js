const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const Fr = require("ffjavascript").bn128.Fr;

const assert = chai.assert;

describe("Comparators test", function ()  {

    this.timeout(100000);

    it("Should create a iszero circuit", async() => {
        const circuit = await tester(path.join(__dirname, "circuits", "iszero.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": 111}, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": 0 }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));
    });
    it("Should create a isequal circuit", async() => {
        const circuit = await tester(path.join(__dirname, "circuits", "isequal.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [111,222] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));


        witness = await circuit.calculateWitness({ "in": [444,444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));
    });
    it("Should create a comparison lessthan", async() => {
        const circuit = await tester(path.join(__dirname, "circuits", "lessthan.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [333,444] }), true;
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in":[1,1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [661, 660] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [1, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [555, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));
    });
    it("Should create a comparison lesseqthan", async() => {

        const circuit = await tester(path.join(__dirname, "circuits", "lesseqthan.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [333,444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in":[1,1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [661, 660] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [1, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [555, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));
    });
    it("Should create a comparison greaterthan", async() => {

        const circuit = await tester(path.join(__dirname, "circuits", "greaterthan.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [333,444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in":[1,1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [661, 660] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [1, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [555, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));
    });
    it("Should create a comparison greatereqthan", async() => {
        const circuit = await tester(path.join(__dirname, "circuits", "greatereqthan.circom"));

        let witness;
        witness = await circuit.calculateWitness({ "in": [333,444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in":[1,1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [661, 660] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 1] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [0, 444] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(0)));

        witness = await circuit.calculateWitness({ "in": [1, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [555, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));

        witness = await circuit.calculateWitness({ "in": [0, 0] }, true);
        assert(Fr.eq(witness[0], Fr.e(1)));
        assert(Fr.eq(witness[1], Fr.e(1)));
    });
});
