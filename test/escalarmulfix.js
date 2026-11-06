const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const buildBabyjub = require("circomlibjs").buildBabyjub;
const Scalar = require("ffjavascript").Scalar;

const assert = chai.assert;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let babyJub;
    let Fr;
    let circuit;

    this.timeout(100000);


    before( async() => {
        babyJub = await buildBabyjub();
        Fr = babyJub.F;
        circuit = await wasm_tester(path.join(__dirname, "circuits", "escalarmulfix_test.circom"));
    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuit.calculateWitness({"e": 0});

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: [0,1]}, true);

    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuit.calculateWitness({"e": 1}, true);

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: [Fr.toObject(babyJub.Base8[0]), Fr.toObject(babyJub.Base8[1])]});

    });

    it("Should generate scalar mul of a specific constant", async () => {

        const s = Scalar.e("2351960337287830298912035165133676222414898052661454064215017316447594616519");
        const base8 = [
            Fr.e("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            Fr.e("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        const w = await circuit.calculateWitness({"e": s}, true);

        await circuit.checkConstraints(w);

        const expectedRes = babyJub.mulPointEscalar(base8, s);

        await circuit.assertOut(w, {out: [Fr.toObject(expectedRes[0]), Fr.toObject(expectedRes[1])]});

    });

    it("Should generate scalar mul of the firsts 50 elements", async () => {

        const base8 = [
            Fr.e("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            Fr.e("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        for (let i=0; i<50; i++) {
            const s = Scalar.e(i);

            const w = await circuit.calculateWitness({"e": s}, true);

            await circuit.checkConstraints(w);

            const expectedRes = babyJub.mulPointEscalar(base8, s);

            await circuit.assertOut(w, {out: [Fr.toObject(expectedRes[0]), Fr.toObject(expectedRes[1])]});
        }
    });

    it("If multiply by order should return 0", async () => {

        const w = await circuit.calculateWitness({"e": babyJub.subOrder }, true);

        await circuit.checkConstraints(w);

        await circuit.assertOut(w, {out: [0,1]});
    });

});

describe("EscalarMulFix exceptional segment scalars", function () {
    let babyJub;
    let Fr;
    let circuit253;

    this.timeout(100000);

    // With 83 windows, the accumulator before the last window plus the last
    // window output equals 2^250 + sum_{k<83} 8^k + s (s = the low 249 bits).
    // It reaches l, i.e. acc = -w, for s0 = l - 2^250 - sum_{k<83} 8^k.
    function exceptionalScalar(subOrder) {
        let q = Scalar.e(0);
        for (let k = 0; k < 83; k++) {
            q = Scalar.add(q, Scalar.shl(1, 3*k));
        }
        return Scalar.sub(Scalar.sub(subOrder, Scalar.shl(1, 250)), q);
    }

    before( async() => {
        babyJub = await buildBabyjub();
        Fr = babyJub.F;
        circuit253 = await wasm_tester(path.join(__dirname, "circuits", "escalarmulfix_test.circom"));
    });

    async function check(circuit, s) {
        const w = await circuit.calculateWitness({"e": s}, true);
        await circuit.checkConstraints(w);
        const expectedRes = babyJub.mulPointEscalar(babyJub.Base8, s);
        await circuit.assertOut(w, {out: [Fr.toObject(expectedRes[0]), Fr.toObject(expectedRes[1])]});
    }

    it("Should compute the formerly exceptional scalar (n = 253)", async () => {
        const s0 = exceptionalScalar(babyJub.subOrder);
        assert(Scalar.lt(s0, Scalar.shl(1, 249)));
        await check(circuit253, s0);
        await check(circuit253, Scalar.add(s0, Scalar.shl(1, 249)));   // with higher bits set
        await check(circuit253, Scalar.add(s0, Scalar.shl(1, 252)));
    });

    it("Should compute scalars at the segment boundary (n = 253)", async () => {
        await check(circuit253, Scalar.sub(Scalar.shl(1, 246), 1));
        await check(circuit253, Scalar.shl(1, 246));
        await check(circuit253, Scalar.sub(Scalar.shl(1, 253), 1));
    });

    it("Should compile and compute with n = 249", async () => {
        const circuit249 = await wasm_tester(path.join(__dirname, "circuits", "escalarmulfix249_test.circom"));
        await check(circuit249, 0);
        await check(circuit249, 1);
        await check(circuit249, exceptionalScalar(babyJub.subOrder));
        await check(circuit249, Scalar.sub(Scalar.shl(1, 249), 1));
    });
});
