const chai = require("chai");
const path = require("path");

const assert = chai.assert;

const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Baby Jubjub twisted Edwards check test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "babycheck_test.circom"));
    });

    it("Should check that (0,1) is a valid point", async() => {
        const w = await circuit.calculateWitness({x: 0, y:1}, true);

        await circuit.checkConstraints(w);
    });

    it("Should check that (1,0) is an invalid point", async() => {
        try {
            await circuit.calculateWitness({x: 1, y: 0}, true);
            assert(false, "Should be a valid point");
        } catch(err) {
            assert(/Constraint\sdoesn't\smatch(.*)168700\s!=\s1/.test(err.message) );
        }
    });

});
