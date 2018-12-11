const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const smt = require("../src/smt.js");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}


describe("SMT test", function () {
    let circuit;
    let tree;

    this.timeout(100000);

    before( async () => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "smtinsert10_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains SMTInsert: " + circuit.nConstraints);

        tree = await smt.newMemEmptyTrie();
    });

    it("Should verify an insert to an empty tree", async () => {
        const key = bigInt(111);
        const value = bigInt(222);

        const res = await tree.insert(key,value);
        let siblings = res.sibblings;
        while (siblings.length<10) siblings.push(bigInt(0));

        const w = circuit.calculateWitness({
            oldRoot: res.oldRoot,
            newRoot: res.newRoot,
            siblings: siblings,
            oldKey: res.oldKey,
            oldValue: res.oldValue,
            isOld0: res.isOld0 ? 1 : 0,
            newKey: key,
            newValue: value
        });

        const root1 = w[circuit.getSignalIdx("main.levels[0].newRoot")];

        console.log("root1: " + root1.toString());
        console.log("root2: " + res.newRoot.toString());
        assert(root1.equals(res.newRoot));

        assert(circuit.checkWitness(w));
    });

    it("It should add another element", async () => {
        const key = bigInt(333);
        const value = bigInt(444);

        const res = await tree.insert(key,value);
        let siblings = res.sibblings;
        while (siblings.length<10) siblings.push(bigInt(0));

        const w = circuit.calculateWitness({
            oldRoot: res.oldRoot,
            newRoot: res.newRoot,
            siblings: siblings,
            oldKey: res.oldKey,
            oldValue: res.oldValue,
            isOld0: res.isOld0 ? 1 : 0,
            newKey: key,
            newValue: value
        });

        const root1 = w[circuit.getSignalIdx("main.levels[0].newRoot")];

        console.log("root1: " + root1.toString());
        console.log("root2: " + res.newRoot.toString());
        assert(root1.equals(res.newRoot));

        assert(circuit.checkWitness(w));
    });
});
