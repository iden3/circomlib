const path = require("path");
const tester = require("circom").tester;

describe("NOT test", function () {

    this.timeout(100000000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "not.test.circom"));
    });

    it("Should NOT 1 = 0", async () => {
        const witness = await circuit.calculateWitness({ "in": "1"}, true);
        await circuit.assertOut(witness, {out: 0});
    });

    it("Should NOT 0 = 1", async () => {
        const witness = await circuit.calculateWitness({ "in": "0"}, true);
        await circuit.assertOut(witness, {out: 1});
    });

});
