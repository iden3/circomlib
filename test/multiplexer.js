const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

describe("Mux4 test", function() {
    this.timeout(100000);
    it("Should create a constant multiplexer 4", async () => {

        const circuit = await tester(path.join(__dirname, "circuits", "mux4_1.circom"));

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
            const w = await circuit.calculateWitness({ "selector": i });

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct16[i]});
        }
    });

    it("Should create a constant multiplexer 3", async () => {

        const circuit = await tester(path.join(__dirname, "circuits", "mux3_1.circom"));

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
            const w = await circuit.calculateWitness({ "selector": i });

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct8[i]});
        }
    });
    it("Should create a constant multiplexer 2", async () => {

        const circuit = await tester(path.join(__dirname, "circuits", "mux2_1.circom"));

        const ct4 = [
            bigInt("37"),
            bigInt("47"),
            bigInt("53"),
            bigInt("71"),
        ];

        for (let i=0; i<4; i++) {
            const w = await circuit.calculateWitness({ "selector": i });

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct4[i]});
        }
    });
    it("Should create a constant multiplexer 1", async () => {

        const circuit = await tester(path.join(__dirname, "circuits", "mux1_1.circom"));

        const ct2 = [
            bigInt("37"),
            bigInt("47"),
        ];

        for (let i=0; i<2; i++) {
            const w = await circuit.calculateWitness({ "selector": i });

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct2[i]});
        }
    });
});
