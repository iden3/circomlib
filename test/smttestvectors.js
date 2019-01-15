const chai = require("chai");
const snarkjs = require("snarkjs");

const smt = require("../src/smt.js");
const mimcjs = require("../src/mimc7.js");

const assert = chai.assert;
const expect = chai.expect;

const bigInt = snarkjs.bigInt;

const bytesToHex = function (buff) {
    return `0x${buff.toString("hex")}`;
};

const hexToBytes = function (hex) {
    if (hex.substr(0, 2) === "0x") {
        return Buffer.from(hex.substr(2), "hex");
    }

    return Buffer.from(hex, "hex");
};

function bigIntToBuffer(number) {
    const buff = Buffer.alloc(32);
    let pos = buff.length - 1;
    while (!number.isZero()) {
        buff[pos] = number.and(255);
        number = number.shiftRight(8);
        pos -= 1;
    }
    return buff;
}

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

function newEntry(arr) {
    return {
        hi: mimcjs.multiHash(arr.slice(2)),
        hv: mimcjs.multiHash(arr.slice(0, 2)),
    };
}

function smtHash(arr) {
    let r = bigInt(0);
    for (let i=0; i<arr.length; i++) {
        r = mimcjs.hash(r, bigInt(arr[i]), 91 );
    }
    return r;
}

describe("[sparse-merkle-tree] Javascript test", function () {
  
    this.timeout(100000);
    before( async () => {
    });

    it("Mimc7 hash", async () => {
        const entries = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)];
        const hi = mimcjs.multiHash(entries.slice(2));
        const hiHex = bytesToHex(bigIntToBuffer(hi));
        expect(hiHex).to.be.equal("0x1fd4bc970a697084ec1f83ecf81936d4a047e27c654752ddbc89f9ed1728e0ab");
        const hv = mimcjs.multiHash(entries.slice(0, 2));
        const hvHex = bytesToHex(bigIntToBuffer(hv));
        expect(hvHex).to.be.equal("0x263924eb9ae730cea9ce31bb9ada695ec3525536b4c058813552b074db36ba9a");
    });


    it("Add one claim", async () => {
        const claim = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)]; 
        const entries = newEntry(claim);
        const tree = await smt.newMemEmptyTrie();
        const key1 = entries.hi;
        const value1 = entries.hv;

        await tree.insert(key1,value1);
        const root = tree.root;
        const rootBuff = bigIntToBuffer(root);
        expect(bytesToHex(rootBuff)).to.be.equal("0x112bae1c89a7a51a9a09e88c2f095bfe8a7d94d7c0cf5ba017a491c3e0b95c8f");
    });

    it("Add two claims", async () => {
        const firstClaim = [bigInt(12), bigInt(45), bigInt(78), bigInt(41)]; 
        const firstEntries = newEntry(firstClaim);
        const secondClaim = [bigInt(33), bigInt(44), bigInt(55), bigInt(66)]; 
        const secondEntries = newEntry(secondClaim);
        const tree = await smt.newMemEmptyTrie();
        const key1 = firstEntries.hi;
        const value1 = firstEntries.hv;
        const key2 = secondEntries.hi;
        const value2 = secondEntries.hv;

        await tree.insert(key1,value1);
        await tree.insert(key2,value2);
        const root = tree.root;
        const rootBuff = bigIntToBuffer(root);
        expect(bytesToHex(rootBuff)).to.be.equal("0x1fb755a3677f8fd6c47b5462b69778ef6383c31d2d498b765e953f8cacaa6744");
    });

});

// describe("SMT Javascript test", function () {
//   this.timeout(100000);
//   before( async () => {
//   });

//   it("Should insert 2 elements and empty them", async () => {
//       const tree = await smt.newMemEmptyTrie();
//       const key1 = bigInt(111);
//       const value1 = bigInt(222);
//       const key2 = bigInt(333);
//       const value2 = bigInt(444);

//       await tree.insert(key1,value1);
//       await tree.insert(key2,value2);
//       await tree.delete(key2);
//       await tree.delete(key1);

//       assert(tree.root.isZero());
//   });

//   it("Should insert 3 elements in dferent order and should be the same", async () => {
//       const keys = [bigInt(8), bigInt(9), bigInt(32)];
//       const values = [bigInt(88), bigInt(99), bigInt(3232)];
//       const tree1 = await smt.newMemEmptyTrie();
//       const tree2 = await smt.newMemEmptyTrie();
//       const tree3 = await smt.newMemEmptyTrie();
//       const tree4 = await smt.newMemEmptyTrie();
//       const tree5 = await smt.newMemEmptyTrie();
//       const tree6 = await smt.newMemEmptyTrie();

//       await tree1.insert(keys[0],values[0]);
//       await tree1.insert(keys[1],values[1]);
//       await tree1.insert(keys[2],values[2]);

//       await tree2.insert(keys[0],values[0]);
//       await tree2.insert(keys[2],values[2]);
//       await tree2.insert(keys[1],values[1]);

//       await tree3.insert(keys[1],values[1]);
//       await tree3.insert(keys[0],values[0]);
//       await tree3.insert(keys[2],values[2]);

//       await tree4.insert(keys[1],values[1]);
//       await tree4.insert(keys[2],values[2]);
//       await tree4.insert(keys[0],values[0]);

//       await tree5.insert(keys[2],values[2]);
//       await tree5.insert(keys[0],values[0]);
//       await tree5.insert(keys[1],values[1]);

//       await tree6.insert(keys[2],values[2]);
//       await tree6.insert(keys[1],values[1]);
//       await tree6.insert(keys[0],values[0]);

//       assert(tree1.root.equals(tree2.root));
//       assert(tree2.root.equals(tree3.root));
//       assert(tree3.root.equals(tree4.root));
//       assert(tree4.root.equals(tree5.root));
//       assert(tree5.root.equals(tree6.root));

//       assert.equal(Object.keys(tree1.db.nodes).length,  Object.keys(tree2.db.nodes).length);
//       assert.equal(Object.keys(tree2.db.nodes).length,  Object.keys(tree3.db.nodes).length);
//       assert.equal(Object.keys(tree3.db.nodes).length,  Object.keys(tree4.db.nodes).length);
//       assert.equal(Object.keys(tree4.db.nodes).length,  Object.keys(tree5.db.nodes).length);
//       assert.equal(Object.keys(tree5.db.nodes).length,  Object.keys(tree6.db.nodes).length);

//       await tree1.delete(keys[0]);
//       await tree1.delete(keys[1]);
//       await tree2.delete(keys[1]);
//       await tree2.delete(keys[0]);
//       assert(tree1.root.equals(tree2.root));

//       await tree3.delete(keys[0]);
//       await tree3.delete(keys[2]);
//       await tree4.delete(keys[2]);
//       await tree4.delete(keys[0]);
//       assert(tree3.root.equals(tree4.root));

//       await tree5.delete(keys[1]);
//       await tree5.delete(keys[2]);
//       await tree6.delete(keys[2]);
//       await tree6.delete(keys[1]);
//       assert(tree5.root.equals(tree6.root));

//       await tree1.delete(keys[2]);
//       await tree2.delete(keys[2]);
//       await tree3.delete(keys[1]);
//       await tree4.delete(keys[1]);
//       await tree5.delete(keys[0]);
//       await tree6.delete(keys[0]);

//       assert(tree1.root.isZero());
//       assert(tree2.root.isZero());
//       assert(tree3.root.isZero());
//       assert(tree4.root.isZero());
//       assert(tree5.root.isZero());
//       assert(tree6.root.isZero());

//       assert.equal(Object.keys(tree1.db.nodes).length, 0);
//       assert.equal(Object.keys(tree2.db.nodes).length, 0);
//       assert.equal(Object.keys(tree3.db.nodes).length, 0);
//       assert.equal(Object.keys(tree4.db.nodes).length, 0);
//       assert.equal(Object.keys(tree5.db.nodes).length, 0);
//       assert.equal(Object.keys(tree6.db.nodes).length, 0);
//   });

//   it("Insert and remove 100 numbers randomly", async () => {
//       function perm(a) {
//           const arr = a.slice();
//           const rArr = [];
//           for (let i=0; i<arr.length; i++) {
//               let rIdx = Math.floor(Math.random() * (arr.length - i));
//               rArr.push(arr[rIdx]);
//               arr[rIdx] = arr[arr.length - i - 1];
//           }
//           return rArr;
//       }
//       const tree = await smt.newMemEmptyTrie();
//       const arr = [];
//       const N = 100;
//       for (let i=0; i<N; i++) {
//           arr.push(bigInt(i));
//       }
//       const insArr = perm(arr);
//       for (let i=0; i<N; i++) {
//           await tree.insert(insArr[i], i);
//       }
//       const delArr = perm(insArr);
//       for (let i=0; i<N; i++) {
//           await tree.delete(delArr[i]);
//       }

//       assert(tree.root.isZero());
//       assert.equal(Object.keys(tree.db.nodes).length, 0);
//   });

//   it("Should test update", async () => {
//       const tree1 = await smt.newMemEmptyTrie();
//       const tree2 = await smt.newMemEmptyTrie();

//       await tree1.insert(8,88);
//       await tree1.insert(9,99,);
//       await tree1.insert(32,3232);

//       await tree2.insert(8,888);
//       await tree2.insert(9,999);
//       await tree2.insert(32,323232);

//       await tree1.update(8, 888);
//       await tree1.update(9, 999);
//       await tree1.update(32, 323232);

//       assert(tree1.root.equals(tree2.root));
//   });

// });