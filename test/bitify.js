const chai = require("chai");
const path = require("path");

const assert = chai.assert;

const Scalar = require("ffjavascript").Scalar;
const F1Field = require("ffjavascript").F1Field;
const utils = require("ffjavascript").utils;
const q = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const F = new F1Field(q);

const wasm_tester = require("circom_tester").wasm;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        if (Scalar.isOdd(Scalar.shr(v,i))) {
            res.push(F.one);
        } else {
            res.push(F.zero);
        }
    }
    return res;
}


describe("bitify test", function () {
    this.timeout(100000);

    let cir1;
    before( async() => {
        cir1 = await wasm_tester(path.join(__dirname, "circuits", "bitify_test.circom"));
    });

    let cir2;
    before( async() => {
        cir2 = await wasm_tester(path.join(__dirname, "circuits", "bitify_strict_test.circom"));
    });
    
    it("Satisfy bitify 645252352 with 30 bits", async () => {
	const inp = 645252352;
        const rout = getBits(inp, 30);
        const w1 = await cir1.calculateWitness({in: inp}, true);
	await cir1.assertOut(w1, {out: rout });
    });
    
    it("Should not satisfy bitify 1345252352 with 30 bits", async () => {
        const inp = 1345252352;
        try {
            await cir1.calculateWitness({in: inp}, true);
            assert(false);
        } catch(err) {
            assert(err.message.includes("Assert Failed"));
        }
    });

    it("Satisfy bitify q - 645252352 with 254 bits", async () => {
	const inp = q - BigInt("645252352");
        const rout = getBits(inp, 254);
        const w1 = await cir2.calculateWitness({in: inp}, true);
	await cir2.assertOut(w1, {out: rout });
    });
});
