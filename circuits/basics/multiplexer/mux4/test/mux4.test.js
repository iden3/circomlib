const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Mux4 test", function() {

    this.timeout(100000);
    
    it("Should create a constant multiplexer 4", async () => {

        const circuit = await tester(path.join(__dirname, "mux4.test.circom"));

        const ct16 = [
            bigInt("123"),
            bigInt("456"),
            bigInt("789"),
            bigInt("012"),
            bigInt("111"),
            bigInt("222"),
            bigInt("333"),
            bigInt("4546"),
            bigInt("134523"),
            bigInt("44356"),
            bigInt("15623"),
            bigInt("4566"),
            bigInt("1223"),
            bigInt("4546"),
            bigInt("4256"),
            bigInt("4456")
        ];

        for (let i=0; i<16; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct16[i]});
        }
    });
    
});
