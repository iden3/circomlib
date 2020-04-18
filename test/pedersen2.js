const path = require("path");

const Fr = require("ffjavascript").bn128.Fr;
const tester = require("circom").tester;

const babyJub = require("../src/babyjub.js");
const pedersen = require("../src/pedersenHash.js");


describe("Pedersen test", function() {
    let circuit;
    this.timeout(100000);
    before( async() => {

        circuit = await tester(path.join(__dirname, "circuits", "pedersen2_test.circom"));
    });
    it("Should pedersen at zero", async () => {

        let w;

        w = await circuit.calculateWitness({ in: 0}, true);

        const b = Buffer.alloc(32);

        const h = pedersen.hash(b);
        const hP = babyJub.unpackPoint(h);

        await circuit.assertOut(w, {out: hP});

    });
    it("Should pedersen with 253 ones", async () => {

        let w;

        const n = Fr.sub(Fr.shl(Fr.one, Fr.e(253)), Fr.one);

        w = await circuit.calculateWitness({ in: n}, true);

        const b = Buffer.alloc(32);
        for (let i=0; i<31; i++) b[i] = 0xFF;
        b[31] = 0x1F;

        const h = pedersen.hash(b);
        const hP = babyJub.unpackPoint(h);

        await circuit.assertOut(w, {out: hP});

    });
});
