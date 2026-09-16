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

const tagsManaging = path.join(__dirname, "..", "circuits", "tags-managing.circom");

// The templates of tags-managing.circom reject bad inputs by making the
// constraints unsatisfiable, so the witness calculator stops on an assert.
async function shouldNotSatisfy(cir, input) {
    try {
        await cir.calculateWitness(input, true);
        assert(false, "the constraints should not be satisfiable for " + JSON.stringify(input));
    } catch (err) {
        assert(err.message.includes("Assert Failed"), err.message);
    }
}

// Bad parameters are rejected by asserts over the parameters themselves, which
// the compiler evaluates, so these circuits never get as far as a witness.
async function shouldNotCompile(body, expected) {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), "circomlib-tags-"));
    const file = path.join(dir, "invalid.circom");
    fs.writeFileSync(file, "pragma circom 2.1.5;\n" +
        "include \"" + tagsManaging + "\";\n" + body);
    try {
        await wasm_tester(file);
        assert(false, "the circuit should not compile");
    } catch (err) {
        assert(err.message.includes("False assert reached"), err.message);
        assert(err.message.includes(expected), err.message);
    } finally {
        fs.rmSync(dir, {recursive: true, force: true});
    }
}


describe("Tags managing test", function () {
    this.timeout(100000);

    describe("BinaryCheck and BinaryCheckArray", function () {
        let cir;
        before( async() => {
            cir = await wasm_tester(path.join(__dirname, "circuits", "tagsmanaging_binary_test.circom"));
        });

        it("Should accept binary values and return them unchanged", async () => {
            const w = await cir.calculateWitness({in: 1, ina: [0, 1, 0]}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out: 1, outa: [0, 1, 0]}, true);

            const w0 = await cir.calculateWitness({in: 0, ina: [1, 1, 1]}, true);
            await cir.assertOut(w0, {out: 0, outa: [1, 1, 1]}, true);
        });

        it("Should not satisfy a non binary single input", async () => {
            await shouldNotSatisfy(cir, {in: 2, ina: [0, 0, 0]});
        });

        it("Should not satisfy a non binary element of the array", async () => {
            await shouldNotSatisfy(cir, {in: 0, ina: [0, 2, 0]});
            await shouldNotSatisfy(cir, {in: 0, ina: [0, 0, F.e(-1)]});
        });
    });

    describe("MaxbitCheck and MaxbitCheckArray", function () {
        // component main = A(8, 2), so the bound is 2**8 - 1 = 255
        let cir;
        before( async() => {
            cir = await wasm_tester(path.join(__dirname, "circuits", "tagsmanaging_maxbit_test.circom"));
        });

        it("Should accept values that fit in 8 bits, bounds included", async () => {
            const w = await cir.calculateWitness({in: 255, ina: [0, 255]}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out: 255, outa: [0, 255]}, true);

            await cir.calculateWitness({in: 0, ina: [128, 7]}, true);
        });

        it("Should not satisfy a single input of 2**8", async () => {
            await shouldNotSatisfy(cir, {in: 256, ina: [0, 0]});
        });

        it("Should not satisfy an element of the array of 2**8", async () => {
            await shouldNotSatisfy(cir, {in: 0, ina: [0, 256]});
        });

        it("Should not satisfy a negative input", async () => {
            await shouldNotSatisfy(cir, {in: F.e(-1), ina: [0, 0]});
        });
    });

    describe("MaxValueCheck, MinValueCheck and MinMaxValueCheck", function () {
        // component main = A(100, 7, 10, 20): inmax <= 100, inmin >= 7,
        // 10 <= inrange <= 20. Each input is driven in turn while the other two
        // are held at a value the circuit accepts.
        let cir;
        const ok = {inmax: 50, inmin: 50, inrange: 15};
        const withInput = (name, value) => Object.assign({}, ok, {[name]: value});

        before( async() => {
            cir = await wasm_tester(path.join(__dirname, "circuits", "tagsmanaging_value_test.circom"));
        });

        it("Should accept values within the bounds and return them unchanged", async () => {
            const w = await cir.calculateWitness(ok, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {outmax: 50, outmin: 50, outrange: 15}, true);
        });

        it("Should accept the bounds themselves", async () => {
            await cir.calculateWitness(withInput("inmax", 100), true);
            await cir.calculateWitness(withInput("inmax", 0), true);
            await cir.calculateWitness(withInput("inmin", 7), true);
            await cir.calculateWitness(withInput("inrange", 10), true);
            await cir.calculateWitness(withInput("inrange", 20), true);
        });

        it("MinValueCheck should accept a value just below the prime", async () => {
            await cir.calculateWitness(withInput("inmin", F.e(-1)), true);
        });

        it("MaxValueCheck should not satisfy a value above the bound", async () => {
            await shouldNotSatisfy(cir, withInput("inmax", 101));
            // 1000 does not even fit in the nbits(100) = 7 bits used internally
            await shouldNotSatisfy(cir, withInput("inmax", 1000));
        });

        it("MinValueCheck should not satisfy a value below the bound", async () => {
            await shouldNotSatisfy(cir, withInput("inmin", 6));
            await shouldNotSatisfy(cir, withInput("inmin", 0));
        });

        it("MinMaxValueCheck should not satisfy a value outside the range", async () => {
            await shouldNotSatisfy(cir, withInput("inrange", 9));
            await shouldNotSatisfy(cir, withInput("inrange", 21));
            // 100 does not even fit in the nbits(20) = 5 bits used internally
            await shouldNotSatisfy(cir, withInput("inrange", 100));
        });

        it("Should reject a minimum of 0, which would wrap ct-1 to p-1", async () => {
            await shouldNotCompile(
                "template A(){ signal input in; signal output out;\n" +
                "    out <== MinValueCheck(0)(in); }\n" +
                "component main = A();",
                "assert(ct >= 1)");
            await shouldNotCompile(
                "template A(){ signal input in; signal output out;\n" +
                "    out <== MinMaxValueCheck(0, 100)(in); }\n" +
                "component main = A();",
                "assert(ct1 >= 1)");
        });
    });

    describe("MaxAbsValueTagCheck", function () {
        // component main = A(1, 2, 5). n = 1 and n = 2 are the widths where
        // nbits(2 * n) > n, so they cover the bit width given to the comparator.
        let cir;
        const ok = {in1: 0, in2: 0, in3: 0};
        const withInput = (name, value) => Object.assign({}, ok, {[name]: value});

        before( async() => {
            cir = await wasm_tester(path.join(__dirname, "circuits", "tagsmanaging_maxabs_test.circom"));
        });

        it("Should accept the whole range [-n, n] and return the input unchanged", async () => {
            const w = await cir.calculateWitness({in1: F.e(-1), in2: 2, in3: F.e(-5)}, true);
            await cir.checkConstraints(w);
            await cir.assertOut(w, {out1: F.e(-1), out2: 2, out3: F.e(-5)}, true);

            for (let n = 0; n <= 5; n++) {
                await cir.calculateWitness(withInput("in3", n), true);
                await cir.calculateWitness(withInput("in3", F.e(-n)), true);
            }
        });

        it("Should not satisfy a value just outside the range", async () => {
            await shouldNotSatisfy(cir, withInput("in1", 2));
            await shouldNotSatisfy(cir, withInput("in1", F.e(-2)));
            await shouldNotSatisfy(cir, withInput("in2", 3));
            await shouldNotSatisfy(cir, withInput("in2", F.e(-3)));
            await shouldNotSatisfy(cir, withInput("in3", 6));
            await shouldNotSatisfy(cir, withInput("in3", F.e(-6)));
        });
    });
});
