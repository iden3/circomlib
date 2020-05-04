const path = require("path");
const tester = require("circom").tester;

const mimcjs = require("../js/mimc_sponge.js");


describe("MiMC Sponge (Feistel) Circuit test", function () {
    let circuit;

    this.timeout(100000);

    it("Should check permutation", async () => {

        circuit = await tester(path.join(__dirname, "_mimc_feistel.test.circom"));

        const w = await circuit.calculateWitness({xL_in: 1, xR_in: 2, k: 3});

        const out2 = mimcjs.hash(1,2,3);

        await circuit.assertOut(w, {xL_out: out2.xL, xR_out: out2.xR});

        await circuit.checkConstraints(w);

    });

});
