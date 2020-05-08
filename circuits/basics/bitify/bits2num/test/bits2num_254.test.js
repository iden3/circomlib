const path = require("path");
const tester = require("circom").tester;
const bigInt = require("big-integer");

async function checkBits2Num( a, circuit, out) {
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

describe("Bits2Num_254 test", function () {

    this.timeout(100000000);

    const r = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495617");
    const rbits = getBits(r, 254);
    const rout = 0; // r = 0  mod r
    
    
    const s = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495622");
    const sbits = getBits(s, 254);
    const sout = 5; // s = r + 5 = 5  mod r    

    // 254 ones
    const n = bigInt.one.shiftLeft(254).minus(bigInt.one);
    const nbits = getBits(n, 254);
    const nout = bigInt("7059779437489773633646340506914701874769131765994106666166191815402473914366"); // n - r
    
    let circuit;
    
    before( async() => {
        circuit = await tester(path.join(__dirname, "bits2num_254.test.circom"));
    });

    it("Should overflow when geq than r", async () => {
        await checkBits2Num(rbits, circuit, rout);
        await checkBits2Num(sbits, circuit, sout);
        await checkBits2Num(nbits, circuit, nout);
    });

});