const chai = require("chai");
const path = require("path");

const assert = chai.assert;

const Scalar = require("ffjavascript").Scalar;
const F1Field = require("ffjavascript").F1Field;
const q = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const F = new F1Field(q);

const wasm_tester = require("circom_tester").wasm;

// bitify_test.circom is Num2Bits(30) followed by Bits2Num(30), constrained to
// return the input it started from, so a witness exists exactly for the values
// that 30 bits can represent.
describe("Bitify test", function () {
    this.timeout(100000);

    const n = 30;
    const max = Scalar.sub(Scalar.shl(1, n), 1);   // 2**30 - 1

    let cir;
    before( async() => {
        cir = await wasm_tester(path.join(__dirname, "circuits", "bitify_test.circom"));
    });

    function getBits(v, n) {
        const res = [];
        for (let i=0; i<n; i++) {
            res.push(Scalar.isOdd(Scalar.shr(Scalar.e(v), i)) ? 1 : 0);
        }
        return res;
    }

    it("Should decompose into the expected bits, least significant first", async () => {
        for (const v of [0, 1, 2, 3, 1023, 1024, 123456789]) {
            const w = await cir.calculateWitness({in: v}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out: getBits(v, n)}, true);
        }
    });

    it("Should round trip the largest value of 30 bits", async () => {
        const w = await cir.calculateWitness({in: max}, true);
        await cir.checkConstraints(w);
        await cir.assertOut(w, {out: getBits(max, n)}, true);
    });

    it("Should not satisfy an input of 2**30", async () => {
        try {
            await cir.calculateWitness({in: Scalar.shl(1, n)}, true);
            assert(false, "2**30 does not fit in 30 bits");
        } catch(err) {
            assert(err.message.includes("Assert Failed"), err.message);
        }
    });

    it("Should not satisfy a negative input", async () => {
        try {
            await cir.calculateWitness({in: F.e(-1)}, true);
            assert(false, "-1 is p-1, which does not fit in 30 bits");
        } catch(err) {
            assert(err.message.includes("Assert Failed"), err.message);
        }
    });
});
