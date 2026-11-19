const path = require("path");
const chai = require("chai");
const assert = chai.assert;
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
const wasm_tester = require("circom_tester").wasm;

const q = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const F = new F1Field(q);

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        res.push(Scalar.isOdd(Scalar.shr(v, i)) ? F.one : F.zero);
    }
    return res;
}

describe("Bin2Num on checked bits (binnums)", function () {
    this.timeout(100000);

    let cir;
    before( async() => {
        cir = await wasm_tester(path.join(__dirname, "..", "circuits", "binnums", "bin2num_test.circom"));
    });

    it("Should accept bits from BinaryCheckArray at 8 and at maxbits() bits", async () => {
        const w = await cir.calculateWitness({in8: getBits(200, 8), in254: getBits(F.e(-1), 254)}, true);
        await cir.assertOut(w, {out8: 200, out254: F.e(-1)});
    });

    it("Should reject the bits of q at maxbits() bits", async () => {
        try {
            await cir.calculateWitness({in8: getBits(0, 8), in254: getBits(q, 254)}, true);
            assert(false);
        } catch(err) {
            assert(err.message.includes("Assert Failed"));
        }
    });

    it("Should reject the bits of q + 1, the other encoding of 1", async () => {
        try {
            await cir.calculateWitness({in8: getBits(0, 8), in254: getBits(Scalar.add(q, 1), 254)}, true);
            assert(false);
        } catch(err) {
            assert(err.message.includes("Assert Failed"));
        }
    });
});
