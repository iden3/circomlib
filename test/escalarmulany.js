const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let circuitEMulAny;

    this.timeout(100000);

    let g = [
        bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
        bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
    ];

    before( async() => {
        circuitEMulAny = await tester(path.join(__dirname, "circuits", "escalarmulany_test.circom"));
    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuitEMulAny.calculateWitness({"e": 1, "p": g});

        // TODO
        // assert(circuitEMulAny.checkWitness(w));

        await circuitEMulAny.assertOut(w, {out: g});

    });

    it("If multiply by order should return 0", async () => {

        const r = bigInt("2736030358979909402780800718157159386076813972158567259200215660948447373041");
        const w = await circuitEMulAny.calculateWitness({"e": r, "p": g});

        // TODO
        // assert(circuitEMulAny.checkWitness(w));

        await circuitEMulAny.assertOut(w, {out: [0,1]});

    });

});

