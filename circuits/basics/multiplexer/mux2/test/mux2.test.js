const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Mux2 test", function() {

    this.timeout(100000);

    it("Should create a constant multiplexer 2", async () => {

        const circuit = await tester(path.join(__dirname, "mux2.test.circom"));

        const ct4 = [
            bigInt("37"),
            bigInt("47"),
            bigInt("53"),
            bigInt("71"),
        ];

        for (let i=0; i<4; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct4[i]});
        }
    });
});
