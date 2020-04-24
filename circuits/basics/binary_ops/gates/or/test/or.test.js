const path = require("path");
const tester = require("circom").tester;

async function checkOr( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("OR test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "or.test.circom"));
    });

    it("Should check truth table", async () => {
        await checkOr(1,1, circuit, 1);
        await checkOr(1,0, circuit, 1);
        await checkOr(0,1, circuit, 1);
        await checkOr(0,0, circuit, 0);
    });
    
});