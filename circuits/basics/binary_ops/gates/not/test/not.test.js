const path = require("path");
const tester = require("circom").tester;

async function checkNot(a, circuit, out) {
    const w = await circuit.calculateWitness({in: a}, true);
    await circuit.assertOut(w, {out: out});
}

describe("NOT test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "not.test.circom"));
    });

    it("Should check truth table", async () => {
        await checkNot(0, circuit, 1);
        await checkNot(1, circuit, 0);
    });

});
