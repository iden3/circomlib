const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        if (v.shr(i).isOdd()) {
            res.push(bigInt.one);
        } else {
            res.push(bigInt.zero);
        }
    }
    return res;
}

const r = bigInt("2736030358979909402780800718157159386076813972158567259200215660948447373041");

describe("Aliascheck test", () => {
    let circuit;
    before( async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "aliascheckbabyjub_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);
    });

    it("Satisfy the aliastest 0", async () => {
        const inp = getBits(bigInt.zero, 251);
        circuit.calculateWitness({in: inp});
    });

    it("Satisfy the aliastest 3", async () => {
        const inp = getBits(bigInt(3), 251);
        circuit.calculateWitness({in: inp});
    });

    it("Satisfy the aliastest r-1", async () => {
        const inp = getBits(r.sub(bigInt.one), 251);
        circuit.calculateWitness({in: inp});
    });

    it("Nhot not satisfy an input of r", async () => {
        const inp = getBits(r, 251);
        try {
            circuit.calculateWitness({in: inp});
            assert(false);
        } catch(err) {
            assert(err.message.indexOf("Constraint doesn't match") >= 0);
            assert(err.message.indexOf("1 != 0") >= 0);
        }
    });

    it("Nhot not satisfy all ones", async () => {
        const inp = getBits(bigInt(1).shl(251).sub(bigInt(1)), 251);
        try {
            circuit.calculateWitness({in: inp});
            assert(false);
        } catch(err) {
            assert(err.message.indexOf("Constraint doesn't match") >= 0);
            assert(err.message.indexOf("1 != 0") >= 0);
        }
    });

});
