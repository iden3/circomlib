const chai = require("chai");
const path = require("path");

const assert = chai.assert;
const bigInt = require("big-integer");

const tester = require("circom").tester;

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        if (v.shiftRight(i).isOdd()) {
            res.push(bigInt.one);
        } else {
            res.push(bigInt.zero);
        }
    }
    return res;
}

const ct = bigInt("12574899965841125748859665329478411236025236211254788521259648301247745896");
const q = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495617");

describe("CompConstant test", function () {
    
    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "compconstant_test.circom"));
    });

    it("0 > ct is FALSE", async () => {
        const inp = getBits(bigInt.zero, 254);
        witness = await circuit.calculateWitness({"in": inp}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("(q-1) > ct is TRUE", async () => {
        const inp = getBits(q.minus(bigInt.one), 254);
        witness = await circuit.calculateWitness({"in": inp}, true);
        await circuit.assertOut(witness, {out: 1});
    });

    it("ct > ct is FALSE", async () => {
        const inp = getBits(ct, 254);
        witness = await circuit.calculateWitness({"in": inp}, true);
        await circuit.assertOut(witness, {out: 0});
    });

});