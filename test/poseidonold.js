const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

const buildPoseidon = require("circomlibjs").buildPoseidon;

const assert = chai.assert;

// poseidon_old.circom is the unoptimized formulation of Poseidon, kept beside
// the optimized poseidon.circom. Both must hash to the same value, so the
// expected results below are the ones already pinned in poseidoncircuit.js.
describe("Poseidon old Circuit test", function () {
    let poseidon;
    let F;
    let circuit3;
    let circuit6;

    this.timeout(1000000);

    before( async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        circuit3 = await wasm_tester(path.join(__dirname, "circuits", "poseidon_old3_test.circom"));
        circuit6 = await wasm_tester(path.join(__dirname, "circuits", "poseidon_old6_test.circom"));
    });

    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]}, true);

        const res2 = poseidon([1, 2]);

        assert(F.eq(F.e("7853200120776062878684798364095072458815029376092732009249414926327459813530"), F.e(res2)));
        await circuit3.assertOut(w, {out : F.toObject(res2)});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [3, 4]}, true);

        const res2 = poseidon([3, 4]);

        assert(F.eq(F.e("14763215145315200506921711489642608356394854266165572616578112107564877678998"), F.e(res2)));
        await circuit3.assertOut(w, {out : F.toObject(res2)});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([1, 2]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [1, 2, 0, 0, 0]}, true);

        const res2 = poseidon([1, 2, 0, 0, 0]);

        assert(F.eq(F.e("1018317224307729531995786483840663576608797660851238720571059489595066344487"), F.e(res2)));
        await circuit6.assertOut(w, {out : F.toObject(res2)});
        await circuit6.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [3, 4, 5, 10, 23]}, true);

        const res2 = poseidon([3, 4, 5, 10, 23]);

        await circuit6.assertOut(w, {out : F.toObject(res2)});
        await circuit6.checkConstraints(w);
    });
});
