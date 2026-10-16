const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const buildEddsa = require("circomlibjs").buildEddsa;
const buildBabyjub = require("circomlibjs").buildBabyjub;

const Scalar = require("ffjavascript").Scalar;

const assert = chai.assert;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

function buffer2bits(buff) {
    const res = [];
    for (let i=0; i<buff.length; i++) {
        for (let j=0; j<8; j++) {
            if ((buff[i]>>j)&1) {
                res.push(1n);
            } else {
                res.push(0n);
            }
        }
    }
    return res;
}


describe("EdDSA Pedersen test", function () {
    let circuit;
    let circuitOld;
    let eddsa;
    let babyJub;
    let F;

    this.timeout(100000);

    before( async () => {
        eddsa = await buildEddsa();
        babyJub = await buildBabyjub();
        F = babyJub.F;
        circuit = await wasm_tester(path.join(__dirname, "circuits", "eddsapedersen_test.circom"));
        // eddsapedersen_old.circom is the previous formulation of the same
        // verifier, so it is driven with the same inputs as the current one.
        circuitOld = await wasm_tester(path.join(__dirname, "circuits", "eddsapedersen_old_test.circom"));
    });

    // Signs the 10 bytes from 0 to 9 and returns the circuit inputs for it.
    function signedInput() {
        const msg = Buffer.from("00010203040506070809", "hex");

//        const prvKey = crypto.randomBytes(32);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signPedersen(prvKey, msg);

        const pSignature = eddsa.packSignature(signature);
        const uSignature = eddsa.unpackSignature(pSignature);

        assert(eddsa.verifyPedersen(msg, uSignature, pubKey));

        return {
            A: buffer2bits(pPubKey),
            R8: buffer2bits(pSignature.slice(0, 32)),
            S: buffer2bits(pSignature.slice(32, 64)),
            msg: buffer2bits(msg)
        };
    }

    async function shouldNotSatisfy(cir, input) {
        try {
            await cir.calculateWitness(input, true);
            assert(false, "the signature should not verify");
        } catch(err) {
            assert(err.message.includes("Assert Failed"), err.message);
        }
    }

    it("Sign a single 10 bytes from 0 to 9", async () => {
        const input = signedInput();

        const w = await circuit.calculateWitness(input, true);

        await circuit.checkConstraints(w);
    });

    it("Detect a tampered message", async () => {
        const input = signedInput();

        input.msg[0] = input.msg[0] === 1n ? 0n : 1n;

        await shouldNotSatisfy(circuit, input);
    });

    it("Detect a tampered signature", async () => {
        const input = signedInput();

        input.S[0] = input.S[0] === 1n ? 0n : 1n;

        await shouldNotSatisfy(circuit, input);
    });

    it("Old verifier should accept the same signature", async () => {
        const input = signedInput();

        const w = await circuitOld.calculateWitness(input, true);

        await circuitOld.checkConstraints(w);
    });

    it("Old verifier should detect a tampered message", async () => {
        const input = signedInput();

        input.msg[0] = input.msg[0] === 1n ? 0n : 1n;

        await shouldNotSatisfy(circuitOld, input);
    });
});
