const chai = require("chai");
const snarkjs = require("snarkjs");

const smt = require("../src/smt.js");
const mimcjs = require("../src/mimc7.js");

const expect = chai.expect;

const bigInt = snarkjs.bigInt;

function bytesToHex(buff) {
    return `0x${buff.toString("hex")}`;
}

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

function newEntry(arr) {
    return {
        hi: mimcjs.multiHash(arr.slice(2)),
        hv: mimcjs.multiHash(arr.slice(0, 2)),
    };
}

describe("[sparse-merkle-tree] Javascript test", function () {
  
    this.timeout(100000);
    before( async () => {
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
        expect(bytesToHex(rootBuff)).to.be.equal("0x2bf39430aa2482fc1e2f170179c8cab126b0f55f71edc8d333f4c80cb4e798f5");
    });
    /*
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

    it("Add claims in different orders", async () => {
        const tree1 = await smt.newMemEmptyTrie();
        for (let i = 0; i < 16; i++) {
            const claim = [bigInt(0), bigInt(i), bigInt(0), bigInt(i)];
            const entries = newEntry(claim);
            await tree1.insert(entries.hi, entries.hv);
        }
        const tree2 = await smt.newMemEmptyTrie();
        for (let i = 0; i < 16; i++) {
            const claim = [bigInt(0), bigInt(i), bigInt(0), bigInt(i)];
            const entries = newEntry(claim);
            await tree2.insert(entries.hi, entries.hv);
        }
        const root1 = bigIntToBuffer(tree1.root);
        const root2 = bigIntToBuffer(tree2.root);
        expect(bytesToHex(root1)).to.be.equal(bytesToHex(root2));
        expect(bytesToHex(root1)).to.be.equal("0x173fd27f6622526dfb21c4d8d83e3c95adba5d8f46a397113e4e80e629c6de76");
    });

    it("Insert 3 elements in different order into different trees", async () => {
        const claim1 = [bigInt(33), bigInt(44), bigInt(55), bigInt(66)];
        const entries1 = newEntry(claim1);
        const claim2 = [bigInt(1111), bigInt(2222), bigInt(3333), bigInt(4444)];
        const entries2 = newEntry(claim2);
        const claim3 = [bigInt(5555), bigInt(6666), bigInt(7777), bigInt(8888)];
        const entries3 = newEntry(claim3);
      
        const tree1 = await smt.newMemEmptyTrie();
        const tree2 = await smt.newMemEmptyTrie();
        const tree3 = await smt.newMemEmptyTrie();
        const tree4 = await smt.newMemEmptyTrie();
        const tree5 = await smt.newMemEmptyTrie();
        const tree6 = await smt.newMemEmptyTrie();

        await tree1.insert(entries1.hi,entries1.hv);
        await tree1.insert(entries2.hi,entries2.hv);
        await tree1.insert(entries3.hi,entries3.hv);

        await tree2.insert(entries1.hi,entries1.hv);
        await tree2.insert(entries3.hi,entries3.hv);
        await tree2.insert(entries2.hi,entries2.hv);

        await tree3.insert(entries2.hi,entries2.hv);
        await tree3.insert(entries1.hi,entries1.hv);
        await tree3.insert(entries3.hi,entries3.hv);

        await tree4.insert(entries2.hi,entries2.hv);
        await tree4.insert(entries3.hi,entries3.hv);
        await tree4.insert(entries1.hi,entries1.hv);

        await tree5.insert(entries3.hi,entries3.hv);
        await tree5.insert(entries1.hi,entries1.hv);
        await tree5.insert(entries2.hi,entries2.hv);

        await tree6.insert(entries3.hi,entries3.hv);
        await tree6.insert(entries2.hi,entries2.hv);
        await tree6.insert(entries1.hi,entries1.hv);
        
        const root1 = bigIntToBuffer(tree1.root);
        const root2 = bigIntToBuffer(tree2.root);
        const root3 = bigIntToBuffer(tree3.root);
        const root4 = bigIntToBuffer(tree4.root);
        const root5 = bigIntToBuffer(tree5.root);
        const root6 = bigIntToBuffer(tree6.root);

        expect(bytesToHex(root1)).to.be.equal(bytesToHex(root2));
        expect(bytesToHex(root2)).to.be.equal(bytesToHex(root3));
        expect(bytesToHex(root3)).to.be.equal(bytesToHex(root4));
        expect(bytesToHex(root4)).to.be.equal(bytesToHex(root5));
        expect(bytesToHex(root5)).to.be.equal(bytesToHex(root6));
        
        expect(bytesToHex(root1)).to.be.equal("0x27990ef22656f49f010b2b48b2418c46f2bc93e4afb2e3377a1eb09f129e9802");
    });
    */
});