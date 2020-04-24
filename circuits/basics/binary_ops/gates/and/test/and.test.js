const path = require("path");
const tester = require("circom").tester;

async function checkAnd( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("AND test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "and.test.circom"));
    });

    it("Should check truth table", async () => {
        await checkAnd(1,1, circuit, 1);
        await checkAnd(1,0, circuit, 0);
        await checkAnd(0,1, circuit, 0);
        await checkAnd(0,0, circuit, 0);
    });
    
});