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

async function testInsert(tree, key, value, circuit, log ) {

    const res = await tree.insert(key,value);
    let siblings = res.sibblings;
    while (siblings.length<10) siblings.push(bigInt(0));

    const w = circuit.calculateWitness({
        fnc: [1,0],
        oldRoot: res.oldRoot,
        newRoot: res.newRoot,
        siblings: siblings,
        oldKey: res.oldKey,
        oldValue: res.oldValue,
        isOld0: res.isOld0 ? 1 : 0,
        newKey: key,
        newValue: value
    }, log);

    const root1 = w[circuit.getSignalIdx("main.topSwitcher.outR")];
    assert(circuit.checkWitness(w));
    assert(root1.equals(res.newRoot));
}

async function testDelete(tree, key, circuit) {
    const res = await tree.delete(key);
    let siblings = res.sibblings;
    while (siblings.length<10) siblings.push(bigInt(0));

    const w = circuit.calculateWitness({
        fnc: [1,1],
        oldRoot: res.oldRoot,
        newRoot: res.newRoot,
        siblings: siblings,
        oldKey: res.oldKey,
        oldValue: res.oldValue,
        isOld0: res.isOld0 ? 1 : 0,
        newKey: res.delKey,
        newValue: res.delValue
    });

    const root1 = w[circuit.getSignalIdx("main.topSwitcher.outR")];

    assert(circuit.checkWitness(w));
    assert(root1.equals(res.newRoot));
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

        await testInsert(tree, key, value, circuit);
    });

    it("It should add another element", async () => {
        const key = bigInt(333);
        const value = bigInt(444);

        await testInsert(tree, key, value, circuit);
    });



    it("Should remove an element", async () => {
        await testDelete(tree, 111, circuit);
        await testDelete(tree, 333, circuit);
    });

    it("Should test convination of adding and removing 3 elements", async () => {
        const keys = [bigInt(8), bigInt(9), bigInt(32)];
        const values = [bigInt(88), bigInt(99), bigInt(3232)];
        const tree1 = await smt.newMemEmptyTrie();
        const tree2 = await smt.newMemEmptyTrie();
        const tree3 = await smt.newMemEmptyTrie();
        const tree4 = await smt.newMemEmptyTrie();
        const tree5 = await smt.newMemEmptyTrie();
        const tree6 = await smt.newMemEmptyTrie();

        await testInsert(tree1,keys[0],values[0], circuit);
        await testInsert(tree1,keys[1],values[1], circuit, console.log);
/*        await testInsert(tree1,keys[2],values[2], circuit);

        await testInsert(tree2,keys[0],values[0], circuit);
        await testInsert(tree2,keys[2],values[2], circuit);
        await testInsert(tree2,keys[1],values[1], circuit);

        await testInsert(tree3,keys[1],values[1], circuit);
        await testInsert(tree3,keys[0],values[0], circuit);
        await testInsert(tree3,keys[2],values[2], circuit);

        await testInsert(tree4,keys[1],values[1], circuit);
        await testInsert(tree4,keys[2],values[2], circuit);
        await testInsert(tree4,keys[0],values[0], circuit);

        await testInsert(tree5,keys[2],values[2], circuit);
        await testInsert(tree5,keys[0],values[0], circuit);
        await testInsert(tree5,keys[1],values[1], circuit);

        await testInsert(tree6,keys[2],values[2], circuit);
        await testInsert(tree6,keys[1],values[1], circuit);
        await testInsert(tree6,keys[0],values[0], circuit);


        await testDelete(tree1, keys[0], circuit);
        await testDelete(tree1, keys[1], circuit);
        await testDelete(tree2, keys[1], circuit);
        await testDelete(tree2, keys[0], circuit);

        await testDelete(tree3, keys[0], circuit);
        await testDelete(tree3, keys[2], circuit);
        await testDelete(tree4, keys[2], circuit);
        await testDelete(tree4, keys[0], circuit);


        await testDelete(tree5, keys[1], circuit);
        await testDelete(tree5, keys[2], circuit);
        await testDelete(tree6, keys[2], circuit);
        await testDelete(tree6, keys[1], circuit);

        await testDelete(tree1, keys[2], circuit);
        await testDelete(tree2, keys[2], circuit);
        await testDelete(tree3, keys[1], circuit);
        await testDelete(tree4, keys[1], circuit);
        await testDelete(tree5, keys[0], circuit);
        await testDelete(tree6, keys[0], circuit); */
    });

    it("Should match a NOp with random vals", async () => {
        let siblings = [];
        while (siblings.length<10) siblings.push(bigInt(88));
        const w = circuit.calculateWitness({
            fnc: [0,0],
            oldRoot: 11,
            newRoot: 22,
            siblings: siblings,
            oldKey: 33,
            oldValue: 44,
            isOld0: 55,
            newKey: 66,
            newValue: 77
        });

        assert(circuit.checkWitness(w));

    });
    it("Should update an element", async () => {

    });

    it("Should verify existance of an element", async () => {

    });

    it("Should verify non existance of an element", async () => {

    });

});
