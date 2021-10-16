const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const tester = wasm_tester

const poseidonPerm = require("../src/poseidonPerm.js");
const poseidonCipher = require("../src/poseidonCipher.js");
const poseidon = require("circomlibjs").poseidon;

const assert = chai.assert;

describe("Poseidon Circuit test", function () {
    let circuit6;
    let circuit3;
    let perm3Circuit;
    let perm6Circuit;
    let decrypt4Circuit;

    this.timeout(1000000);

    before( async () => {
        circuit3 = await tester(path.join(__dirname, "circuits", "poseidon3_test.circom"));
        circuit6 = await tester(path.join(__dirname, "circuits", "poseidon6_test.circom"));
        perm3Circuit = await tester(path.join(__dirname, "circuits", "poseidonPerm3_test.circom"));
        perm6Circuit = await tester(path.join(__dirname, "circuits", "poseidonPerm6_test.circom"));
        decrypt4Circuit = await tester(path.join(__dirname, "circuits", "poseidonDecrypt4_test.circom"));
    });

    it("poseidon decryption circuit l=4", async () => {
        const message = [1, 2, 3, 4];
        const key = [123, 456];
        const ciphertext = poseidonCipher.encrypt(message, key, 0);
        const decrypted = poseidonCipher.decrypt(ciphertext, key, 0, message.length);
        const inputs = {
            nonce: 0,
            key,
            ciphertext
        };
        const w = await decrypt4Circuit.calculateWitness(inputs, true);
        await decrypt4Circuit.assertOut(w, {"decrypted[0]" : decrypted[0]});
        await decrypt4Circuit.checkConstraints(w);
    });

    it("poseidonPerm circuit t=3", async () => {
        const inputs = [0, 1, 2];
        const res = poseidonPerm(inputs);

        const w = await perm3Circuit.calculateWitness({inputs}, true);
        await perm3Circuit.assertOut(w, {"out[0]" : res[0]});
        await perm3Circuit.assertOut(w, {"out[1]" : res[1]});
        await perm3Circuit.assertOut(w, {"out[2]" : res[2]});
        await perm3Circuit.checkConstraints(w);
    });

    it("poseidonPerm circuit t=6", async () => {
        const inputs = [0, 1, 2, 3, 4];
        const res = poseidonPerm(inputs);

        const w = await perm6Circuit.calculateWitness({inputs}, true);
        await perm6Circuit.assertOut(w, {"out[0]" : res[0]});
        await perm6Circuit.assertOut(w, {"out[1]" : res[1]});
        await perm6Circuit.assertOut(w, {"out[2]" : res[2]});
        await perm6Circuit.assertOut(w, {"out[3]" : res[3]});
        await perm6Circuit.assertOut(w, {"out[4]" : res[4]});
        await perm6Circuit.checkConstraints(w);
    });

    it("Should check constrain of hash([1, 2]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [1, 2, 0,0,0]}, true);

        const res2 = poseidon([1,2,0,0,0]);

        assert.equal("1018317224307729531995786483840663576608797660851238720571059489595066344487", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [3, 4,5,10,23]});

        const res2 = poseidon([3, 4,5,10,23]);

        assert.equal("13034429309846638789535561449942021891039729847501137143363028890275222221409", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });


    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]});

        const res2 = poseidon([1,2]);

        assert.equal("7853200120776062878684798364095072458815029376092732009249414926327459813530", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [3, 4]});

        const res2 = poseidon([3, 4]);

        assert.equal("14763215145315200506921711489642608356394854266165572616578112107564877678998", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });
});
