const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

function toBits(x, n) {
    const res = [];
    for (let i = 0; i < n; i++) res.push((x >> BigInt(i)) & 1n);
    return res;
}

async function shouldNotCompile(file) {
    let compiled = false;
    try {
        await wasm_tester(path.join(__dirname, "circuits", file));
        compiled = true;
    } catch (err) {
        if (!err.message.includes("compiler error")) throw err;
    }
    if (compiled) throw new Error(file + " should not compile");
}

describe("Binary sum test", function () {
    this.timeout(100000000);

    it("Should create a constant circuit", async () => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "constants_test.circom"));
        await circuit.loadConstraints();
        assert.equal(circuit.nVars, 2);
        assert.equal(circuit.constraints.length, 1);

        const witness = await circuit.calculateWitness({ "in": Fr.toString(Fr.e("0xd807aa98"))}, true);

        assert(Fr.eq(Fr.e(witness[0]),Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]),Fr.e("0xd807aa98")));
    });
    it("Should create a sum circuit", async () => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "binsum_test.circom"));
        await circuit.loadConstraints();

        // assert.equal(circuit.constraints.length, 97);  // 32 (in1) + 32(in2) + 32(out) + 1 (carry) with --O2
        assert.equal(circuit.constraints.length, 101);  // 32 (in1) + 32(in2) + 32(out) + 1 (carry) + 4 linear with --O1

        const witness = await circuit.calculateWitness({ "a": "111", "b": "222" }, true);

        assert(Fr.eq(Fr.e(witness[0]),Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]),Fr.e("333")));
    });
    it("Should add four 250-bit values at the widest allowed size", async () => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "binsum_max_test.circom"));
        const ones = (1n << 250n) - 1n;
        for (const vals of [[ones, ones, ones, ones], [ones, 0n, 1n, 12345678901234567890n]]) {
            const w = await circuit.calculateWitness({ in: vals.map(v => toBits(v, 250)) }, true);
            await circuit.checkConstraints(w);
            const sum = vals.reduce((x, y) => x + y, 0n);
            await circuit.assertOut(w, { out: toBits(sum, 252) });
        }
    });
    it("Should refuse a width at which the output bits could alias mod p", async () => {
        // BinSum(252, 2): the sum needs 253 bits, and the bits of p satisfied the
        // constraints for a sum of 0 before the width was bounded.
        await shouldNotCompile("binsum_wide_test.circom");
    });
});
