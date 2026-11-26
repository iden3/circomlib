const path = require("path");

const Scalar = require("ffjavascript").Scalar;
const wasm_tester = require("circom_tester").wasm;

function toBits(x, n) {
    const res = [];
    for (let i = 0; i < n; i++) res.push((x >> BigInt(i)) & 1n);
    return res;
}

async function shouldNotCompile(file) {
    let compiled = false;
    try {
        await wasm_tester(path.join(__dirname, "circuits", file));
        compiled = true;
    } catch (err) {
        if (!err.message.includes("compiler error")) throw err;
    }
    if (compiled) throw new Error(file + " should not compile");
}

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

async function checkSub(_a,_b, circuit) {
    let a=Scalar.e(_a);
    let b=Scalar.e(_b);
    if (Scalar.lt(a, 0)) a = Scalar.add(a, Scalar.shl(1, 16));
    if (Scalar.lt(b, 0)) b = Scalar.add(b, Scalar.shl(1, 16));
    const w = await circuit.calculateWitness({a: a, b: b}, true);

    let res = Scalar.sub(a, b);
    if (Scalar.lt(res, 0)) res = Scalar.add(res, Scalar.shl(1, 16));

    await circuit.assertOut(w, {out: res});
}

describe("BinSub test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await wasm_tester(path.join(__dirname, "circuits", "binsub_test.circom"));
    });

    it("Should check variuos ege cases", async () => {
        await checkSub(0,0, circuit);
        await checkSub(1,0, circuit);
        await checkSub(-1,0, circuit);
        await checkSub(2,1, circuit);
        await checkSub(2,2, circuit);
        await checkSub(2,3, circuit);
        await checkSub(2,-1, circuit);
        await checkSub(2,-2, circuit);
        await checkSub(2,-3, circuit);
        await checkSub(-2,-3, circuit);
        await checkSub(-2,-2, circuit);
        await checkSub(-2,-1, circuit);
        await checkSub(-2,0, circuit);
        await checkSub(-2,1, circuit);
        await checkSub(-2,2, circuit);
        await checkSub(-2,3, circuit);
    });



    it("Should subtract at the widest allowed size", async () => {
        const wide = await wasm_tester(path.join(__dirname, "circuits", "binsub_max_test.circom"));
        const ones = (1n << 252n) - 1n;
        for (const [a, b] of [[0n, ones], [ones, 0n], [ones, ones], [5n, 7n]]) {
            const w = await wide.calculateWitness({ in: [toBits(a, 252), toBits(b, 252)] }, true);
            await wide.checkConstraints(w);
            const diff = ((a - b) % (1n << 252n) + (1n << 252n)) % (1n << 252n);
            await wide.assertOut(w, { out: toBits(diff, 252) });
        }
    });
    it("Should refuse a width at which the result could alias mod p", async () => {
        // BinSub(253): for 0 - (2^253 - 1) both out = 1 and out = p + 1 - 2^253 with
        // the borrow flipped satisfied the constraints before the width was bounded.
        await shouldNotCompile("binsub_wide_test.circom");
    });
});
