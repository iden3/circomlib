const chai = require("chai");
const path = require("path");
const os = require("os");
const fs = require("fs");

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

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        res.push(Scalar.isOdd(Scalar.shr(Scalar.e(v), i)) ? 1 : 0);
    }
    return res;
}

describe("Bitify strict test", function () {
    this.timeout(100000);

    const n = 254;                                 // maxbits() for this field
    const allOnes = Scalar.sub(Scalar.shl(1, n), 1);

    let cir;
    before( async() => {
        cir = await wasm_tester(path.join(__dirname, "circuits", "bitify_strict_test.circom"));
    });

    async function shouldNotSatisfy(input) {
        try {
            await cir.calculateWitness(input, true);
            assert(false, "the alias check should reject " + JSON.stringify(input.inb.length));
        } catch(err) {
            assert(err.message.includes("Assert Failed"), err.message);
        }
    }

    it("Num2Bits_strict should decompose any field element", async () => {
        for (const v of [0, 1, 3, F.e(-1)]) {
            const w = await cir.calculateWitness({in: v, inb: getBits(0, n)}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {bits: getBits(v, n)}, true);
        }
    });

    it("Bits2Num_strict should recompose bits below the prime", async () => {
        for (const v of [0, 1, 3, F.e(-1)]) {
            const w = await cir.calculateWitness({in: 0, inb: getBits(v, n)}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {num: F.e(v)}, true);
        }
    });

    it("Bits2Num_strict should not satisfy the bits of the prime", async () => {
        await shouldNotSatisfy({in: 0, inb: getBits(q, n)});
    });

    it("Bits2Num_strict should not satisfy 254 ones", async () => {
        await shouldNotSatisfy({in: 0, inb: getBits(allOnes, n)});
    });
});

describe("Num2BitsNeg test", function () {
    this.timeout(100000);

    // 2**253 is the largest power of two below the prime, so 253 is the widest width the
    // template accepts; there its result is exactly 2**253 - in as an integer.
    const pow253 = Scalar.shl(1, 253);

    let cir;
    before( async() => {
        cir = await wasm_tester(path.join(__dirname, "circuits", "bitify_neg_test.circom"));
    });

    it("Should return the n bits of 2**n - in", async () => {
        for (const v of [1, 3, 17, 255, 256]) {
            const w = await cir.calculateWitness({in8: v, in253: 1}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out8: getBits(Scalar.sub(256, v), 8)}, true);
        }
    });

    it("Should return all zeros for an input of 0", async () => {
        const w = await cir.calculateWitness({in8: 0, in253: 0}, true);
        await cir.checkConstraints(w);
        await cir.assertOut(w, {out8: getBits(0, 8), out253: getBits(0, 253)}, true);
    });

    it("Should return exactly 2**253 - in at the widest allowed width", async () => {
        for (const v of [1, 3, 17, Scalar.sub(pow253, 1), pow253]) {
            const w = await cir.calculateWitness({in8: 1, in253: v}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out253: getBits(Scalar.sub(pow253, v), 253)}, true);
        }
    });

    it("Should not satisfy an input whose negation needs more than n bits", async () => {
        for (const [i8, i253] of [[257, 1], [1000, 1], [1, Scalar.add(pow253, 1)]]) {
            try {
                await cir.calculateWitness({in8: i8, in253: i253}, true);
                assert(false, "2**n - in does not fit in n bits");
            } catch(err) {
                assert(err.message.includes("Assert Failed"), err.message);
            }
        }
    });

    it("Should reject n = maxbits() at compile time, for both the array and the bus template", async () => {
        const circuits = path.join(__dirname, "..", "circuits");
        for (const [inc, call] of [["bitify.circom", "signal output {binary} o[254] <== Num2BitsNeg(254)(in);"],
                                   ["binnum.circom", "BinaryNumber(254) output {unique} o <== Num2BinNeg(254)(in);"]]) {
            const dir = fs.mkdtempSync(path.join(os.tmpdir(), "circomlib-neg-"));
            const file = path.join(dir, "invalid.circom");
            fs.writeFileSync(file, "pragma circom 2.2.0;\ninclude \"" + path.join(circuits, inc) + "\";\n" +
                "template A(){ signal input in; " + call + " }\ncomponent main = A();\n");
            try {
                await wasm_tester(file);
                assert(false, inc + ": n = 254 should not compile");
            } catch (err) {
                assert(err.message.includes("False assert reached"), err.message);
            } finally {
                fs.rmSync(dir, {recursive: true, force: true});
            }
        }
    });
});
