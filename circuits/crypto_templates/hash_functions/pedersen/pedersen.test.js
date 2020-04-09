const path = require("path");

const bigInt = require("big-integer");
const tester = require("circom").tester;

const babyJub = require("../../../../src/babyjub.js");
const pedersen = require("../../../../src/pedersenHash.js");


describe("Pedersen test", function() {
    let circuit;
    this.timeout(100000);
    before( async() => {

        circuit = await tester(path.join(__dirname, "pedersen_test.circom"));
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

        const n = bigInt.one.shiftLeft(253).minus(bigInt.one);

        w = await circuit.calculateWitness({ in: n}, true);

        const b = Buffer.alloc(32);
        for (let i=0; i<31; i++) b[i] = 0xFF;
        b[31] = 0x1F;

        const h = pedersen.hash(b);
        const hP = babyJub.unpackPoint(h);

        await circuit.assertOut(w, {out: hP});

    });
});
