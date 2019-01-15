const chai = require("chai");
const snarkjs = require("snarkjs");

const smt = require("../src/smt.js");
const mimcjs = require("../src/mimc7.js");

const assert = chai.assert;
const expect = chai.expect;

const bigInt = snarkjs.bigInt;

function stringifyBigInts(o) {
    if ((typeof(o) == "bigint") || (o instanceof bigInt))  {
        return o.toString(10);
    } else if (Array.isArray(o)) {
        return o.map(stringifyBigInts);
    } else if (typeof o == "object") {
        const res = {};
        for (let k in o) {
            res[k] = stringifyBigInts(o[k]);
        }
        return res;
    } else {
        return o;
    }
}

function newEntryFromInts(a, b, c, d) {
    return {
        hi: mimcjs.hash(c, d),
        hv: mimcjs.hash(a, b),
    };
}

function smtHash(arr) {
    let r = bigInt(0);
    for (let i=0; i<arr.length; i++) {
        r = mimcjs.hash(r, bigInt(arr[i]), 91 );
    }
    return r;
}

describe("SMT Javascript test", function () {
    this.timeout(100000);
    before( async () => {
    });

    it("test MIMC7", async() => {
        //const h = mimcjs.multiHash(1,2,3);
        //const h = smtHash([1,2,3]);
        //console.log(h.toString(10));

const mimcjs = require("../src/mimc7.js");
const snarkjs = require("snarkjs");
const bigInt = snarkjs.bigInt;
const smt = require("../src/smt.js");

h = mimcjs.hash(1,2,91);
console.log(h);

function smtHash(arr) {
    let r = bigInt(0);
    for (let i=0; i<arr.length; i++) {
        r = mimcjs.hash(r, bigInt(arr[i]), 91 );
    }
    return r;
}

console.log(smtHash([1, 2, 3]));
        // Test from old ver
    });

    //it("Should calculate hindex", async() => {
    //    const entry = newEntryFromInts(12, 45, 78, 41);
    //    //console.log(entry.hi.toString(16));
    //    expect(entry.hi.toString(16)).to.be.
    //        equal("114438e8321f62c4a1708f443a5a66f9c8fcb0958e7b7008332b71442610b7a0");
    //});

    //it("Should insert 2 elements and empty them", async () => {
    //    const tree = await smt.newMemEmptyTrie();
    //    const key1 = bigInt(111);
    //    const value1 = bigInt(222);
    //    const key2 = bigInt(333);
    //    const value2 = bigInt(444);

    //    await tree.insert(key1,value1);
    //    await tree.insert(key2,value2);
    //    await tree.delete(key2);
    //    await tree.delete(key1);

    //    assert(tree.root.isZero());
    //});

    //it("Should insert 3 elements in dferent order and should be the same", async () => {
    //    const keys = [bigInt(8), bigInt(9), bigInt(32)];
    //    const values = [bigInt(88), bigInt(99), bigInt(3232)];
    //    const tree1 = await smt.newMemEmptyTrie();
    //    const tree2 = await smt.newMemEmptyTrie();
    //    const tree3 = await smt.newMemEmptyTrie();
    //    const tree4 = await smt.newMemEmptyTrie();
    //    const tree5 = await smt.newMemEmptyTrie();
    //    const tree6 = await smt.newMemEmptyTrie();

    //    await tree1.insert(keys[0],values[0]);
    //    await tree1.insert(keys[1],values[1]);
    //    await tree1.insert(keys[2],values[2]);

    //    await tree2.insert(keys[0],values[0]);
    //    await tree2.insert(keys[2],values[2]);
    //    await tree2.insert(keys[1],values[1]);

    //    await tree3.insert(keys[1],values[1]);
    //    await tree3.insert(keys[0],values[0]);
    //    await tree3.insert(keys[2],values[2]);

    //    await tree4.insert(keys[1],values[1]);
    //    await tree4.insert(keys[2],values[2]);
    //    await tree4.insert(keys[0],values[0]);

    //    await tree5.insert(keys[2],values[2]);
    //    await tree5.insert(keys[0],values[0]);
    //    await tree5.insert(keys[1],values[1]);

    //    await tree6.insert(keys[2],values[2]);
    //    await tree6.insert(keys[1],values[1]);
    //    await tree6.insert(keys[0],values[0]);

    //    assert(tree1.root.equals(tree2.root));
    //    assert(tree2.root.equals(tree3.root));
    //    assert(tree3.root.equals(tree4.root));
    //    assert(tree4.root.equals(tree5.root));
    //    assert(tree5.root.equals(tree6.root));

    //    assert.equal(Object.keys(tree1.db.nodes).length,  Object.keys(tree2.db.nodes).length);
    //    assert.equal(Object.keys(tree2.db.nodes).length,  Object.keys(tree3.db.nodes).length);
    //    assert.equal(Object.keys(tree3.db.nodes).length,  Object.keys(tree4.db.nodes).length);
    //    assert.equal(Object.keys(tree4.db.nodes).length,  Object.keys(tree5.db.nodes).length);
    //    assert.equal(Object.keys(tree5.db.nodes).length,  Object.keys(tree6.db.nodes).length);

    //    await tree1.delete(keys[0]);
    //    await tree1.delete(keys[1]);
    //    await tree2.delete(keys[1]);
    //    await tree2.delete(keys[0]);
    //    assert(tree1.root.equals(tree2.root));

    //    await tree3.delete(keys[0]);
    //    await tree3.delete(keys[2]);
    //    await tree4.delete(keys[2]);
    //    await tree4.delete(keys[0]);
    //    assert(tree3.root.equals(tree4.root));

    //    await tree5.delete(keys[1]);
    //    await tree5.delete(keys[2]);
    //    await tree6.delete(keys[2]);
    //    await tree6.delete(keys[1]);
    //    assert(tree5.root.equals(tree6.root));

    //    await tree1.delete(keys[2]);
    //    await tree2.delete(keys[2]);
    //    await tree3.delete(keys[1]);
    //    await tree4.delete(keys[1]);
    //    await tree5.delete(keys[0]);
    //    await tree6.delete(keys[0]);

    //    assert(tree1.root.isZero());
    //    assert(tree2.root.isZero());
    //    assert(tree3.root.isZero());
    //    assert(tree4.root.isZero());
    //    assert(tree5.root.isZero());
    //    assert(tree6.root.isZero());

    //    assert.equal(Object.keys(tree1.db.nodes).length, 0);
    //    assert.equal(Object.keys(tree2.db.nodes).length, 0);
    //    assert.equal(Object.keys(tree3.db.nodes).length, 0);
    //    assert.equal(Object.keys(tree4.db.nodes).length, 0);
    //    assert.equal(Object.keys(tree5.db.nodes).length, 0);
    //    assert.equal(Object.keys(tree6.db.nodes).length, 0);
    //});

    //it("Insert and remove 100 numbers randomly", async () => {
    //    function perm(a) {
    //        const arr = a.slice();
    //        const rArr = [];
    //        for (let i=0; i<arr.length; i++) {
    //            let rIdx = Math.floor(Math.random() * (arr.length - i));
    //            rArr.push(arr[rIdx]);
    //            arr[rIdx] = arr[arr.length - i - 1];
    //        }
    //        return rArr;
    //    }
    //    const tree = await smt.newMemEmptyTrie();
    //    const arr = [];
    //    const N = 100;
    //    for (let i=0; i<N; i++) {
    //        arr.push(bigInt(i));
    //    }
    //    const insArr = perm(arr);
    //    for (let i=0; i<N; i++) {
    //        await tree.insert(insArr[i], i);
    //    }
    //    const delArr = perm(insArr);
    //    for (let i=0; i<N; i++) {
    //        await tree.delete(delArr[i]);
    //    }

    //    assert(tree.root.isZero());
    //    assert.equal(Object.keys(tree.db.nodes).length, 0);
    //});

    //it("Should test update", async () => {
    //    const tree1 = await smt.newMemEmptyTrie();
    //    const tree2 = await smt.newMemEmptyTrie();

    //    await tree1.insert(8,88);
    //    await tree1.insert(9,99,);
    //    await tree1.insert(32,3232);

    //    await tree2.insert(8,888);
    //    await tree2.insert(9,999);
    //    await tree2.insert(32,323232);

    //    await tree1.update(8, 888);
    //    await tree1.update(9, 999);
    //    await tree1.update(32, 323232);

    //    assert(tree1.root.equals(tree2.root));
    //});

});

