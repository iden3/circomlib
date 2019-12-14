const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;
const babyjub = require("../src/babyjub");

const assert = chai.assert;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let circuit;

    this.timeout(100000);

    before( async() => {
        circuit = await tester(path.join(__dirname, "circuits", "escalarmulfix_test.circom"));
    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuit.calculateWitness({"e": 0});

        // TODO
        // assert(circuit.checkWitness(w));

        await circuit.assertOut(w, {out: [0,1]});

    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuit.calculateWitness({"e": 1});

        // TODO
        // assert(circuit.checkWitness(w));

        await circuit.assertOut(w, {out: babyjub.Base8});

    });

    it("Should generate scalar mul of a specific constant", async () => {

        const s = bigInt("2351960337287830298912035165133676222414898052661454064215017316447594616519");
        const base8 = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        const w = await circuit.calculateWitness({"e": s});

        // TODO
        // assert(circuit.checkWitness(w));

        const expectedRes = babyjub.mulPointEscalar(base8, s);

        await circuit.assertOut(w, {out: expectedRes});

    });

    it("Should generate scalar mul of the firsts 50 elements", async () => {

        const base8 = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        for (let i=0; i<50; i++) {
            const s = bigInt(i);

            const w = await circuit.calculateWitness({"e": s});

            // TODO
            // assert(circuit.checkWitness(w));

            const expectedRes = babyjub.mulPointEscalar(base8, s);

            await circuit.assertOut(w, {out: expectedRes});
        }
    });

    it("If multiply by order should return 0", async () => {

        const w = await circuit.calculateWitness({"e": babyjub.subOrder });

        // TODO
        // assert(circuit.checkWitness(w));

        await circuit.assertOut(w, {out: [0,1]});
    });

});

