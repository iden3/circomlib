const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;
const babyJub = require("../../../../../../../src/babyjub");

const assert = chai.assert;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Scalarmulw4table (exponentiation) test", function () {

    this.timeout(100000);

    it("Should generate the Exponentiation table for k=0", async () => {

        const circuit = await tester(path.join(__dirname, "scalarmulw4table_test.circom"));

        const w = await circuit.calculateWitness({in: 1});

        await circuit.checkConstraints(w);

        let g = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        let dbl= [bigInt("0"), bigInt("1")];

        const expectedOut = [];

        for (let i=0; i<16; i++) {

            expectedOut.push(dbl);
            dbl = babyJub.addPoint(dbl,g);
        }

        await circuit.assertOut(w, {out: expectedOut});

    });

    it("Should generate the Exponentiation table for k=3", async () => {

        const circuit = await tester(path.join(__dirname, "scalarmulw4table_test3.circom"));

        const w = await circuit.calculateWitness({in: 1});

        await circuit.checkConstraints(w);

        let g = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        for (let i=0; i<12;i++) {
            g = babyJub.addPoint(g,g);
        }

        let dbl= [bigInt("0"), bigInt("1")];

        const expectedOut = [];

        for (let i=0; i<16; i++) {
            expectedOut.push(dbl);

            dbl = babyJub.addPoint(dbl,g);
        }

        await circuit.assertOut(w, {out: expectedOut});

    });

//    TODO: Add last test.
});
