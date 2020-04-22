const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Mux1 test", function() {

    this.timeout(100000);
    
    it("Should create a constant multiplexer 1", async () => {

        const circuit = await tester(path.join(__dirname, "mux1.test.circom"));

        const ct2 = [
            bigInt("37"),
            bigInt("47"),
        ];

        for (let i=0; i<2; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct2[i]});
        }
    });
});
