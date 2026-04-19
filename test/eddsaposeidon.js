const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

const buildEddsa = require("circomlibjs").buildEddsa;
const buildBabyjub = require("circomlibjs").buildBabyjub;

const assert = chai.assert;

describe("EdDSA Poseidon test", function () {
    let circuit;
    let eddsa;
    let babyJub;
    let F;

    this.timeout(100000);

    before( async () => {
        eddsa = await buildEddsa();
        babyJub = await buildBabyjub();
        F = babyJub.F;
        circuit = await wasm_tester(path.join(__dirname, "circuits", "eddsaposeidon_test.circom"));
    });

    it("Sign a single number", async () => {
        const msg = F.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));

        const input = {
            enabled: 1,
            "A.x": F.toObject(pubKey[0]),
            "A.y": F.toObject(pubKey[1]),
            "R8.x": F.toObject(signature.R8[0]),
            "R8.y": F.toObject(signature.R8[1]),
            S: signature.S,
            M: F.toObject(msg)
        };

        // console.log(JSON.stringify(utils.stringifyBigInts(input)));

        const w = await circuit.calculateWitness(input, true);

        await circuit.checkConstraints(w);
    });

    it("Detect Invalid signature", async () => {
        const msg = F.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));
        try {
            await circuit.calculateWitness({
                enabled: 1,
                "A.x": F.toObject(pubKey[0]),
                "A.y": F.toObject(pubKey[1]),
                "R8.x": F.toObject(F.add(signature.R8[0], F.e(1))),
                "R8.y": F.toObject(signature.R8[1]),
                S: signature.S,
                M: F.toObject(msg)}, true);
            assert(false);
        } catch(err) {
	    assert(err.message.includes("Assert Failed"));
        }
    });


    it("Test a dissabled circuit with a bad signature", async () => {
        const msg = F.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));

        const w = await circuit.calculateWitness({
            enabled: 0,
            "A.x": F.toObject(pubKey[0]),
            "A.y": F.toObject(pubKey[1]),
            //"R8.x": F.toObject(F.add(signature.R8[0], F.e(1))),
            //"R8.y": F.toObject(signature.R8[1]),
            // fails becauses it is not a point in the curve
            "R8.x": F.toObject(pubKey[0]),
            "R8.y": F.toObject(pubKey[1]),
            // This is a bad signature
            S: signature.S,
            M: F.toObject(msg)}, true);

        await circuit.checkConstraints(w);
    });
});
