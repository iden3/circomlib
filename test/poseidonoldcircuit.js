const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

const buildPoseidon = require("circomlibjs").buildPoseidon;

const assert = chai.assert;

describe("Poseidon(old) Circuit test", function () {
    let poseidon;
    let F;
    let circuit3;
    this.timeout(1000000);

    before( async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        circuit3 = await wasm_tester(path.join(__dirname, "circuits", "poseidonold3_test.circom"));
    });

    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]});

        const res2 = poseidon([1,2]);

        assert(F.eq(F.e("7853200120776062878684798364095072458815029376092732009249414926327459813530"), F.e(res2)));
        await circuit3.assertOut(w, {out : F.toObject(res2)});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [3, 4]});

        const res2 = poseidon([3, 4]);

        assert(F.eq(F.e("14763215145315200506921711489642608356394854266165572616578112107564877678998"), F.e(res2)));
        await circuit3.assertOut(w, {out : F.toObject(res2)});
        await circuit3.checkConstraints(w);
    });

});
