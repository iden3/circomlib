const bigInt = require("snarkjs").bigInt;

class SMTMemDb {
    constructor() {
        this.nodes = {};
        this.root = bigInt(0);
    }

    async getRoot() {
        return this.root;
    }

    async get(key) {
        const res = [];
        const keyS = bigInt(key).leInt2Buff(32).toString("hex");
        for (let i=0; i<this.nodes[keyS].length; i++) {
            res.push(bigInt(this.nodes[keyS][i]));
        }
        return res;
    }

    async save(root, inserts) {
        for (let i=0; i<inserts.length; i++) {
            const keyS = bigInt(inserts[i][0]).leInt2Buff(32).toString("hex");
            this.nodes[keyS] = inserts[i][1];
        }
        this.root = root;
    }
}

module.exports = SMTMemDb;
