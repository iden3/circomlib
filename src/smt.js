const bigInt = require("snarkjs").bigInt;

const SMTMemDB = require("./smt_memdb");
const mimc7 = require("./mimc7").hash;

function smtHash(arr) {
    let r = bigInt(0);
    for (let i=0; i<arr.length; i++) {
        r = mimc7(r, bigInt(arr[i]));
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

    async delete(_key) {
        const key = bigInt(_key);

        const resFind = await this.find(key);
        if (!resFind.found) throw new Error("Key does not exists");

        const res = {
            sibblings: [],
            delKey: key,
            delValue: resFind.foundValue
        };

        const dels = [];
        const ins = [];
        let rtOld = smtHash([1, key, resFind.foundValue]);
        let rtNew;
        dels.push(rtOld);


        let mixed;
        if (resFind.sibblings.length > 0) {
            const record = await this.db.get(resFind.sibblings[resFind.sibblings.length - 1]);
            if ((record.length == 3)&&(record[0].equals(bigInt.one))) {
                mixed = false;
                res.oldKey = record[1];
                res.oldValue = record[2];
                res.isOld0 = false;
                rtNew = resFind.sibblings[resFind.sibblings.length - 1];
            } else if (record.length == 2) {
                mixed = true;
                res.oldKey = key;
                res.oldValue = bigInt(0);
                res.isOld0 = true;
                rtNew = bigInt.zero;
            } else {
                throw new Error("Invalid node. Database corrupted");
            }
        } else {
            rtNew = bigInt.zero;
            res.oldKey = key;
            res.oldValue = bigInt(0);
            res.isOld0 = true;
        }

        const keyBits = this._splitBits(key);

        for (let level = resFind.sibblings.length-1; level >=0; level--) {
            let newSibling = resFind.sibblings[level];
            if ((level == resFind.sibblings.length-1)&&(!res.isOld0)) {
                newSibling = bigInt.zero;
            }
            const oldSibling = resFind.sibblings[level];
            if (keyBits[level]) {
                rtOld = smtHash([oldSibling, rtOld]);
            } else {
                rtOld = smtHash([rtOld, oldSibling]);
            }
            dels.push(rtOld);
            if (!newSibling.isZero()) {
                mixed = true;
            }

            if (mixed) {
                res.sibblings.unshift(resFind.sibblings[level]);
                let newNode;
                if (keyBits[level]) {
                    newNode = [newSibling, rtNew];
                } else {
                    newNode = [rtNew, newSibling];
                }
                rtNew = smtHash(newNode);
                ins.push([rtNew, newNode]);
            }
        }

        await this.db.multiIns(ins);
        await this.db.setRoot(rtNew);
        this.root = rtNew;
        await this.db.multiDel(dels);

        res.newRoot = rtNew;
        res.oldRoot = rtOld;

        return res;
    }

    async insert(_key, _value) {
        const key = bigInt(_key);
        const value = bigInt(_value);
        let addedOne = false;
        const res = {};
        res.oldRoot = this.root;
        const newKeyBits = this._splitBits(key);

        let rtOld;

        const resFind = await this.find(key);

        if (resFind.found) throw new Error("Key already exists");

        res.sibblings = resFind.sibblings;
        let mixed;

        if (!resFind.isOld0) {
            const oldKeyits = this._splitBits(resFind.notFoundKey);
            for (let i= res.sibblings.length; oldKeyits[i] == newKeyBits[i]; i++) {
                res.sibblings.push(bigInt.zero);
            }
            rtOld = smtHash([1, resFind.notFoundKey, resFind.notFoundValue]);
            res.sibblings.push(rtOld);
            addedOne = true;
            mixed = false;
        } else if (res.sibblings.length >0) {
            mixed = true;
            rtOld = bigInt.zero;
        }

        const inserts = [];
        const dels = [];

        let rt = smtHash([1, key, value]);
        inserts.push([rt,[1, key, value]] );

        for (let i=res.sibblings.length-1; i>=0; i--) {
            if ((i<res.sibblings.length-1)&&(!res.sibblings[i].isZero())) {
                mixed = true;
            }
            if (mixed) {
                const oldSibling = resFind.sibblings[i];
                if (newKeyBits[i]) {
                    rtOld = smtHash([oldSibling, rtOld]);
                } else {
                    rtOld = smtHash([rtOld, oldSibling]);
                }
                dels.push(rtOld);
            }


            let newRt;
            if (newKeyBits[i]) {
                newRt = smtHash([res.sibblings[i], rt]);
                inserts.push([newRt,[res.sibblings[i], rt]] );
            } else {
                newRt = smtHash([rt, res.sibblings[i]]);
                inserts.push([newRt,[rt, res.sibblings[i]]] );
            }
            rt = newRt;
        }

        if (addedOne) res.sibblings.pop();
        while ((res.sibblings.length>0) && (res.sibblings[res.sibblings.length-1].isZero())) {
            res.sibblings.pop();
        }
        res.oldKey = resFind.notFoundKey;
        res.oldValue = resFind.notFoundValue;
        res.newRoot = rt;
        res.isOld0 = resFind.isOld0;


        await this.db.multiIns(inserts);
        await this.db.setRoot(rt);
        this.root = rt;
        await this.db.multiDel(dels);

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
                res = await this._find(key, keyBits, record[0], level+1);
                res.sibblings.unshift(record[1]);
            } else {
                res = await this._find(key, keyBits, record[1], level+1);
                res.sibblings.unshift(record[0]);
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
