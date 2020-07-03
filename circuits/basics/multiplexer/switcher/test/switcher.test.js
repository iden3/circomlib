const path = require("path");
sconst tester = require("circom").tester;
const bigInt = require("big-integer");

describe("Switcher test", function () {

    this.timeout(100000000);

    L = bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553");
    R = bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203");

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "switcher.test.circom"));
    });

    it("Should not switch the inputs if sel = 0", async () => {
        const witness = await circuit.calculateWitness({L: L, R: R, sel: 0}, true);
        await circuit.assertOut(witness, {outL: L, outR: R});
    });
    
    it("Should switch the inputs if sel = 1", async () => {
        const witness = await circuit.calculateWitness({L: L, R: R, sel: 1}, true);
        await circuit.assertOut(witness, {outL: R, outR: L});
    });
});