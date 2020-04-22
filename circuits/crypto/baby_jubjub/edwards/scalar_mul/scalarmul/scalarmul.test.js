const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;
const babyJub = require("../../../../../../src/babyjub");

const assert = chai.assert;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Scalarmul (exponentiation) test", function () {

    it("Should exponentiate g^31", async () => {

        const circuit = await tester(path.join(__dirname, "scalarmul_test.circom"));

        const w = await circuit.calculateWitness({"in": 31});

        await circuit.checkConstraints(w);

        let g = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        let c = [bigInt(0), bigInt(1)];

        for (let i=0; i<31;i++) {
            c = babyJub.addPoint(c,g);
        }

        await circuit.assertOut(w, {out: c});

        const w2 = await circuit.calculateWitness({"in": bigInt(1).shiftLeft(252).add(bigInt.one)});

        c = [g[0], g[1]];
        for (let i=0; i<252;i++) {
            c = babyJub.addPoint(c,c);
        }
        c = babyJub.addPoint(c,g);

        await circuit.assertOut(w2, {out: c});

    }).timeout(10000000);

    it("Number of constraints for 256 bits", async () => {

        const circuit = await tester(path.join(__dirname, "scalarmul_test_min.circom"));

    }).timeout(10000000);

});