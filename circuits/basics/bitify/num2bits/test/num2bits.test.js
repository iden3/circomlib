const path = require("path");
const tester = require("circom").tester;
const bigInt = require("big-integer");

async function checkNum2Bits( a, circuit, out) {
    const w = await circuit.calculateWitness({in: a}, true);
    await circuit.assertOut(w, {out: out});
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

describe("Num2Bits test", function () {

    this.timeout(100000000);

    const a = bigInt("3");
    const abits = getBits(a, 254);

    const b = bigInt("2569");
    const bbits = getBits(b, 254);

    const c = bigInt("25600025600089");
    const cbits = getBits(c, 254);

    const r = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495617");
    const rout = getBits(bigInt.zero, 254); // r = 0  mod r
    
    const s = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495622");
    const sout = getBits(bigInt("5"), 254); // s = r + 5 = 5  mod r    

    let circuit;
    
    before( async() => {
        circuit = await tester(path.join(__dirname, "num2bits.test.circom"));
    });

    it("Should work with small numbers", async () => {
        await checkNum2Bits(a, circuit, abits);
        await checkNum2Bits(b, circuit, bbits);
        await checkNum2Bits(c, circuit, cbits);
    });

    it("Should overflow when geq than r", async () => {
        await checkNum2Bits(r, circuit, rout);
        await checkNum2Bits(s, circuit, sout);
    });

});