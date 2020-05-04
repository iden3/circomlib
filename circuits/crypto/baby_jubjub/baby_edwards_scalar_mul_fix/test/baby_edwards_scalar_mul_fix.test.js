const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;
const babyjub = require("../../js/baby_jubjub");

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Scalar_mul_fix test", function () {
    let circuit;

    this.timeout(100000);

    before( async() => {
        circuit = await tester(path.join(__dirname, "baby_edwards_scalar_mul_fix.test.circom"));
    });

    it("Should generate same scalar_mul", async () => {

        const w = await circuit.calculateWitness({"e": 0});

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: [0,1]}, true);

    });

    it("Should generate same scalar_mul", async () => {

        const w = await circuit.calculateWitness({"e": 1}, true);

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: babyjub.Base8});

    });

    it("Should generate scalar_mul of a specific constant", async () => {

        const s = bigInt("2351960337287830298912035165133676222414898052661454064215017316447594616519");
        const base8 = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        const w = await circuit.calculateWitness({"e": s}, true);

        await circuit.checkConstraints(w);

        const expectedRes = babyjub.mulPointEscalar(base8, s);

        await circuit.assertOut(w, {out: expectedRes});

    });

    it("Should generate scalar_mul of the first 50 elements", async () => {

        const base8 = [
            bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        for (let i=0; i<50; i++) {
            const s = bigInt(i);

            const w = await circuit.calculateWitness({"e": s}, true);

            await circuit.checkConstraints(w);

            const expectedRes = babyjub.mulPointEscalar(base8, s);

            await circuit.assertOut(w, {out: expectedRes});
        }
    });

    it("If multiplied by order should return 0", async () => {

        const w = await circuit.calculateWitness({"e": babyjub.subOrder }, true);

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: [0,1]});
    });

});