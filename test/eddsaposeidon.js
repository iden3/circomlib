const chai = require("chai");
const path = require("path");
const tester = require("circom").tester;
const Fr = require("ffjavascript").bn128.Fr;

const eddsa = require("../src/eddsa.js");

const assert = chai.assert;

describe("EdDSA Poseidon test", function () {
    let circuit;

    this.timeout(100000);

    before( async () => {

        circuit = await tester(path.join(__dirname, "circuits", "eddsaposeidon_test.circom"));

    });

    it("Sign a single number", async () => {
        const msg = Fr.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));

        const input = {
            enabled: 1,
            Ax: pubKey[0],
            Ay: pubKey[1],
            R8x: signature.R8[0],
            R8y: signature.R8[1],
            S: signature.S,
            M: msg
        };

        // console.log(JSON.stringify(utils.stringifyBigInts(input)));

        const w = await circuit.calculateWitness(input, true);

        await circuit.checkConstraints(w);
    });

    it("Detect Invalid signature", async () => {
        const msg = Fr.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));
        try {
            await circuit.calculateWitness({
                enabled: 1,
                Ax: pubKey[0],
                Ay: pubKey[1],
                R8x: Fr.add(signature.R8[0], Fr.e(1)),
                R8y: signature.R8[1],
                S: signature.S,
                M: msg}, true);
            assert(false);
        } catch(err) {
            assert(/Constraint\sdoesn't\smatch(.*)1\s!=\s0/.test(err.message) );
        }
    });


    it("Test a dissabled circuit with a bad signature", async () => {
        const msg = Fr.e(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));

        const w = await circuit.calculateWitness({
            enabled: 0,
            Ax: pubKey[0],
            Ay: pubKey[1],
            R8x: Fr.add(signature.R8[0], Fr.e(1)),
            R8y: signature.R8[1],
            S: signature.S,
            M: msg}, true);

        await circuit.checkConstraints(w);
    });
});
