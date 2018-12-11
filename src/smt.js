const bigInt = require("snarkjs").bigInt;

const SMTMemDB = require("./smt_memdb");
const mimc7 = require("./mimc7");

function smtHash(arr) {
    let r = bigInt(0);
    for (let i=0; i<arr.length; i++) {
        r = mimc7.hash(r, bigInt(arr[i]), 91 );
    }
    return r;
}

class SMT {

    constructor(db, root) {
        this.db = db;
        this.root = root;
    }

    _splitBits(_key) {

        let k = bigInt(_key);
        const res = [];

        while (!k.isZero()) {
            if (k.isOdd()) {
                res.push(true);
            } else {
                res.push(false);
            }
            k = k.shr(1);
        }

        while (res.length<256) res.push(false);

        return res;
    }

    async insert(_key, _value) {
        const key = bigInt(_key);
        const value = bigInt(_value);
        let addedOne = false;
        const res = {};
        res.oldRoot = this.root;
        const newKeyBits = this._splitBits(key);
        const resFind = await this.find(key);

        if (resFind.found) throw new Error("Key already exists");

        res.sibblings = resFind.sibblings;

        if (!resFind.isOld0) {
            const oldKeyits = this._splitBits(resFind.notFoundKey);
            for (let i= res.sibblings.length; oldKeyits[i] == newKeyBits[i]; i++) {
                res.sibblings.push(bigInt.zero);
            }
            res.sibblings.push(smtHash([1, resFind.notFoundKey, resFind.notFoundValue]));
            addedOne = true;
        }

        const inserts = [];

        let rt = smtHash([1, key, value]);
        inserts.push([rt,[1, key, value]] );

        for (let i=res.sibblings.length-1; i>=0; i--) {
            if (newKeyBits[i]) {
                rt = smtHash([res.sibblings[i], rt]);
                inserts.push([rt,[res.sibblings[i], rt]] );
            } else {
                rt = smtHash([rt, res.sibblings[i]]);
                inserts.push([rt,[rt, res.sibblings[i]]] );
            }
        }

        if (addedOne) res.sibblings.pop();
        while ((res.sibblings.length>0) && (res.sibblings[res.sibblings.length-1].isZero())) {
            res.sibblings.pop();
        }
        res.oldKey = resFind.notFoundKey;
        res.oldValue = resFind.notFoundValue;
        res.newRoot = rt;
        res.isOld0 = resFind.isOld0;

        this.root = rt;

        await this.db.save(rt, inserts);

        return res;
    }

    async find(key) {
        const keyBits = this._splitBits(key);
        return await this._find(key, keyBits, this.root, 0);
    }

    async _find(key, keyBits, root, level) {
        if (typeof root === "undefined") root = this.root;

        let res;
        if (root.isZero()) {
            res = {
                found: false,
                sibblings: [],
                notFoundKey: key,
                notFoundValue: bigInt.zero,
                isOld0: true
            };
            return res;
        }

        const record = await this.db.get(root);

        if ((record.length==3)&&(record[0].equals(bigInt.one))) {
            if (record[1].equals(key)) {
                res = {
                    found: true,
                    sibblings: [],
                    foundValue: record[2],
                    isOld0: false
                };
            } else {
                res = {
                    found: false,
                    sibblings: [],
                    notFoundKey: record[1],
                    notFoundValue: record[2],
                    isOld0: false
                };
            }
        } else {
            if (keyBits[level] == 0) {
                const res = await this.find(key, keyBits, record[1], level+1);
                res.sibblings.unshift(record[2]);
            } else {
                res = await this.find(key, keyBits, record[2], level+1);
                res.sibblings.unshift(record[1]);
            }
        }
        return res;
    }
}

async function loadFromFile(fileName) {

}

async function newMemEmptyTrie() {
    const db = new SMTMemDB();
    const rt = await db.getRoot();
    const smt = new SMT(db, rt);
    return smt;
}

module.exports.loadFromFile = loadFromFile;
module.exports.newMemEmptyTrie = newMemEmptyTrie;
