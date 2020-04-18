const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const Fr = require("ffjavascript").bn128.Fr;

const assert = chai.assert;

describe("Binary sum test", function () {

    this.timeout(100000000);

    it("Should create a constant circuit", async () => {
        const circuit = await tester(path.join(__dirname, "circuits", "constants_test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nVars, 2);
        assert.equal(circuit.constraints.length, 1);

        const witness = await circuit.calculateWitness({ "in": Fr.e("d807aa98", 16)}, true);

        assert(Fr.eq(witness[0],Fr.e(1)));
        assert(Fr.eq(witness[1],Fr.e("d807aa98", 16)));
    });
    it("Should create a sum circuit", async () => {
        const circuit = await tester(path.join(__dirname, "circuits", "sum_test.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.constraints.length, 97);  // 32 (in1) + 32(in2) + 32(out) + 1 (carry)

        const witness = await circuit.calculateWitness({ "a": "111", "b": "222" }, true);

        assert(Fr.eq(witness[0],Fr.e(1)));
        assert(Fr.eq(witness[1],Fr.e("333")));
    });
});
