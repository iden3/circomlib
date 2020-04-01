const path = require("path");

const bigInt = require("big-integer");
const tester = require("circom").tester;

function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

async function checkSub(_a,_b, circuit) {
    let a=bigInt(_a);
    let b=bigInt(_b);
    if (a.lesser(bigInt.zero)) a = a.add(bigInt.one.shiftLeft(16));
    if (b.lesser(bigInt.zero)) b = b.add(bigInt.one.shiftLeft(16));
    const w = await circuit.calculateWitness({a: a, b: b}, true);

    let res = a.minus(b);
    if (res.lesser(bigInt.zero)) res = res.add(bigInt.one.shiftLeft(16));
    await circuit.assertOut(w, {out: bigInt(res)});
}

describe("BinSub test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "circuits", "binsub_test.circom"));
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


});
