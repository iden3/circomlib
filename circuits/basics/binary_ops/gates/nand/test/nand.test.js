const path = require("path");
const tester = require("circom").tester;

async function checkNand( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("NAND test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "nand.test.circom"));
    });

    it("Should satisfy truth table", async () => {
        await checkNand(1,1, circuit, 0);
        await checkNand(1,0, circuit, 1);
        await checkNand(0,1, circuit, 1);
        await checkNand(0,0, circuit, 1);
    });
    
});