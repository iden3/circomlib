const path = require("path");
const tester = require("circom").tester;

async function checkNor( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("NOR test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "nor.test.circom"));
    });

    it("Should satisfy truth table", async () => {
        await checkNor(1,1, circuit, 0);
        await checkNor(1,0, circuit, 0);
        await checkNor(0,1, circuit, 0);
        await checkNor(0,0, circuit, 1);
    });
    
});