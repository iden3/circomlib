const path = require("path");
const tester = require("circom").tester;

async function checkBits2Num( a, circuit, out) {
    const w = await circuit.calculateWitness({in: a}, true);
    await circuit.assertOut(w, {out: out});
}


describe("Bits2Num test", function () {

    this.timeout(100000000);

    let circuit;
    
    before( async() => {
        circuit = await tester(path.join(__dirname, "bits2num.test.circom"));
    });

    it("Should work with small numbers", async () => {
        await checkBits2Num([0,0,1], circuit, 4);
        await checkBits2Num([1,1,0], circuit, 3);
        await checkBits2Num([1,1,1], circuit, 7);
    });

});
