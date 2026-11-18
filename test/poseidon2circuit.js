const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

const buildPoseidon = require("circomlibjs").buildPoseidon;

const assert = chai.assert;

describe("Poseidon2 Circuit test", function () {
    let poseidon;
    let F;
    let circuit3;

    this.timeout(1000000);

    before( async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        circuit3 = await wasm_tester(path.join(__dirname, "circuits", "poseidon_v2_3_test.circom"));
    });

    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]});

        const res = "19016777872907576614311050386253173408873004339574005400462870923562919648648";
        //const res2 = poseidon([1,2]);

        // assert(F.eq(F.e("7853200120776062878684798364095072458815029376092732009249414926327459813530"), F.e(res2)));
        // await circuit3.assertOut(w, {out : F.toObject(res2)});
        await circuit3.assertOut(w, {out : res});
        await circuit3.checkConstraints(w);
    });

});
