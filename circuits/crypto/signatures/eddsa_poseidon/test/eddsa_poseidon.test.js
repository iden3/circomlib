const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

const eddsa = require("../../js/eddsa");
const babyJub = require("../../../baby_jubjub/js/baby_jubjub");
const utils = require("../../../../../src/utils.js");

const assert = chai.assert;

describe("EdDSA Poseidon test", function () {
    let circuit;

    this.timeout(100000);

    before( async () => {

        circuit = await tester(path.join(__dirname, "eddsa_poseidon.test.circom"));

    });

    it("Sign a single number", async () => {
        const msg = bigInt(1234);

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

    it("Detect invalid signature", async () => {
        const msg = bigInt(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));
        try {
            await circuit.calculateWitness({
                enabled: 1,
                Ax: pubKey[0],
                Ay: pubKey[1],
                R8x: signature.R8[0].add(bigInt(1)),
                R8y: signature.R8[1],
                S: signature.S,
                M: msg}, true);
            assert(false);
        } catch(err) {
            assert(/Constraint\sdoesn't\smatch(.*)1\s!=\s0/.test(err.message) );
        }
    });


    it("Test a disabled circuit with a bad signature", async () => {
        const msg = bigInt(1234);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);


        const signature = eddsa.signPoseidon(prvKey, msg);

        assert(eddsa.verifyPoseidon(msg, signature, pubKey));

        const w = await circuit.calculateWitness({
            enabled: 0,
            Ax: pubKey[0],
            Ay: pubKey[1],
            R8x: signature.R8[0].add(bigInt(1)),
            R8y: signature.R8[1],
            S: signature.S,
            M: msg}, true);

        await circuit.checkConstraints(w);
    });

    it("Sign a single 10 bytes from 0 to 9", () => {
        const msgBuf = Buffer.from("00010203040506070809", "hex");
        const msg = utils.leBuff2int(msgBuf);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        assert.equal(pubKey[0].toString(),
            "13277427435165878497778222415993513565335242147425444199013288855685581939618");
        assert.equal(pubKey[1].toString(),
            "13622229784656158136036771217484571176836296686641868549125388198837476602820");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signPoseidon(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "11384336176656855268977457483345535180380036354188103142384839473266348197733");
        assert.equal(signature.R8[1].toString(),
            "15383486972088797283337779941324724402501462225528836549661220478783371668959");
        assert.equal(signature.S.toString(),
            "248298168863866362217836334079793350221620631973732197668910946177382043688");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "dfedb4315d3f2eb4de2d3c510d7a987dcab67089c8ace06308827bf5bcbe02a2"+
            "28506bce274aa1b3f7e7c2fd7e4fe09bff8f9aa37a42def7994e98f322888c00");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyPoseidon(msg, uSignature, pubKey));

    });
});
