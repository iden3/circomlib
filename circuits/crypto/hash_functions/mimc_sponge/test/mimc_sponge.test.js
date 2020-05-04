const path = require("path");
const tester = require("circom").tester;

const mimcjs = require("../js/mimc_sponge.js");


describe("MiMC Sponge Circuit test", function () {
    let circuit;

    this.timeout(100000);

    it("Should check hash", async () => {
        circuit = await tester(path.join(__dirname, "mimc_sponge.test.circom"));

        const w = await circuit.calculateWitness({ins: [1, 2], k: 0});

        const out2 = mimcjs.multiHash([1,2], 0, 3);

        await circuit.assertOut(w, {outs: out2});

        await circuit.checkConstraints(w);
    });
});
