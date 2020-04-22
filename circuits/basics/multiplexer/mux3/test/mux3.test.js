const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Mux3 test", function() {

    this.timeout(100000);

    it("Should create a constant multiplexer 3", async () => {

        const circuit = await tester(path.join(__dirname, "mux3.test.circom"));

        const ct8 = [
            bigInt("37"),
            bigInt("47"),
            bigInt("53"),
            bigInt("71"),
            bigInt("89"),
            bigInt("107"),
            bigInt("163"),
            bigInt("191")
        ];

        for (let i=0; i<8; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct8[i]});
        }
    });

});
