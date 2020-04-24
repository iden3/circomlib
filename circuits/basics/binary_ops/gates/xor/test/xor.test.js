const path = require("path");
const tester = require("circom").tester;

async function checkXor( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("XOR test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "xor.test.circom"));
    });

    it("Should check truth table", async () => {
        await checkXor(1,1, circuit, 0);
        await checkXor(1,0, circuit, 1);
        await checkXor(0,1, circuit, 1);
        await checkXor(0,0, circuit, 0);
    });
    
});