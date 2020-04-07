const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

function getBits(v, n) {
    const res = [];
    for (let i=0; i<n; i++) {
        if (v.shiftRight(i).isOdd()) {
            res.push(bigInt.one);
        } else {
            res.push(bigInt.zero);
        }
    }
    return res;
}

const q = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495617");

describe("Sign test", function() {
    let circuit;
    this.timeout(100000);

    before( async() => {
        circuit = await tester(path.join(__dirname, "sign_test.circom"));
    });

    it("Sign of 0", async () => {
        const inp = getBits(bigInt.zero, 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 0});
    });

    it("Sign of 3", async () => {
        const inp = getBits(bigInt(3), 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 0});
    });

    it("Sign of q/2", async () => {
        const inp = getBits(q.shiftRight(bigInt.one), 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 0});
    });

    it("Sign of q/2+1", async () => {
        const inp = getBits(q.shiftRight(bigInt.one).add(bigInt.one), 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 1});
    });

    it("Sign of q-1", async () => {
        const inp = getBits(q.minus(bigInt.one), 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 1});
    });

    it("Sign of q", async () => {
        const inp = getBits(q, 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 1});
    });

    it("Sign of all ones", async () => {
        const inp = getBits(bigInt(1).shiftLeft(254).minus(bigInt(1)), 254);
        const w = await circuit.calculateWitness({in: inp}, true);

        await circuit.assertOut(w, {sign: 1});
    });
});
