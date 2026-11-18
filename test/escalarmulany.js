const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const buildBabyjub = require("circomlibjs").buildBabyjub;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let circuitEMulAny;

    this.timeout(100000);

    let g;

    before( async() => {
        circuitEMulAny = await wasm_tester(path.join(__dirname, "circuits", "escalarmulany_test.circom"));
        g = [
                Fr.e("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
                Fr.e("16950150798460657717958625567821834550301663161624707787222815936182638968203")
            ]
    });

    it("Should generate Same escalar mul", async () => {

        const w = await circuitEMulAny.calculateWitness({"e": 1, "p": g});

        await circuitEMulAny.checkConstraints(w);

        await circuitEMulAny.assertOut(w, {out: g}, true);

    });

    it("If multiply by order should return 0", async () => {

        const r = Fr.e("2736030358979909402780800718157159386076813972158567259200215660948447373041");
        const w = await circuitEMulAny.calculateWitness({"e": r, "p": g});

        await circuitEMulAny.checkConstraints(w);

        await circuitEMulAny.assertOut(w, {out: [0,1]}, true);

    });

});

describe("EscalarMulAny one-bit segment", function () {
    let babyJub;
    let F;
    let circuit1;
    let circuit149;

    this.timeout(100000);

    before( async() => {
        babyJub = await buildBabyjub();
        F = babyJub.F;
        circuit1 = await wasm_tester(path.join(__dirname, "circuits", "escalarmulany1_test.circom"));
        circuit149 = await wasm_tester(path.join(__dirname, "circuits", "escalarmulany149_test.circom"));
    });

    function toObj(P) {
        return [F.toObject(P[0]), F.toObject(P[1])];
    }

    async function check(circuit, e, P) {
        const w = await circuit.calculateWitness({"e": e, "p": toObj(P)}, true);
        await circuit.checkConstraints(w);
        await circuit.assertOut(w, {out: toObj(babyJub.mulPointEscalar(P, e))});
    }

    it("Should multiply by a single bit (n = 1)", async () => {
        const points = [babyJub.Base8, babyJub.mulPointEscalar(babyJub.Base8, 5)];
        for (const P of points) {
            await check(circuit1, 0, P);
            await check(circuit1, 1, P);
        }
    });

    it("Should return the identity for the identity point (n = 1)", async () => {
        const w = await circuit1.calculateWitness({"e": 1, "p": [0, 1]}, true);
        await circuit1.checkConstraints(w);
        await circuit1.assertOut(w, {out: [0, 1]});
    });

    it("Should handle a one-bit last segment (n = 149)", async () => {
        const P = babyJub.mulPointEscalar(babyJub.Base8, 5);
        const scalars = [
            Scalar.e(0),
            Scalar.e(1),
            Scalar.shl(1, 148),                                // only the one-bit segment set
            Scalar.add(Scalar.shl(1, 148), 12345),
            Scalar.sub(Scalar.shl(1, 149), 1),                 // all bits set
        ];
        for (const e of scalars) {
            await check(circuit149, e, P);
        }
    });
});
