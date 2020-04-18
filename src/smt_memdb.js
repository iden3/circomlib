
const F = require("./poseidon.js").F;
const Scalar = require("ffjavascript").Scalar;

class SMTMemDb {
    constructor() {
        this.nodes = {};
        this.root = F.zero;
    }

    async getRoot() {
        return this.root;
    }

    _key2str(k) {
        // const keyS = bigInt(key).leInt2Buff(32).toString("hex");
        const keyS = Scalar.e(k);
        return keyS;
    }

    _normalize(n) {
        for (let i=0; i<n.length; i++) {
            n[i] = F.e(n[i]);
        }
    }

    async get(key) {
        const keyS = this._key2str(key);
        return this.nodes[keyS];
    }

    async multiGet(keys) {
        const promises = [];
        for (let i=0; i<keys.length; i++) {
            promises.push(this.get(keys[i]));
        }
        return await Promise.all(promises);
    }

    async setRoot(rt) {
        this.root = rt;
    }

    async multiIns(inserts) {
        for (let i=0; i<inserts.length; i++) {
            const keyS = this._key2str(inserts[i][0]);
            this._normalize(inserts[i][1]);
            this.nodes[keyS] = inserts[i][1];
        }
    }

    async multiDel(dels) {
        for (let i=0; i<dels.length; i++) {
            const keyS = this._key2str(dels[i]);
            delete this.nodes[keyS];
        }
    }
}

module.exports = SMTMemDb;
