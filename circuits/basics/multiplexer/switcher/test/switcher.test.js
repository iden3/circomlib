/*
const path = require("path");
const tester = require("circom").tester;

async function checkAnd( a, b, circuit, out) {
    const w = await circuit.calculateWitness({a: a, b: b}, true);
    await circuit.assertOut(w, {out: out});
}

describe("switcher test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "switcher.test.circom"));
    });

    it("Should check truth table", async () => {
        await checkAnd(1,1, circuit, 1);
        await checkAnd(1,0, circuit, 0);
        await checkAnd(0,1, circuit, 0);
        await checkAnd(0,0, circuit, 0);
    });
    
});

template Switcher() {
    signal input sel;
    signal input L;
    signal input R;
    signal output outL;
    signal output outR;

    signal aux;

    aux <== (R-L)*sel;    // We create aux in order to have only one multiplication
    outL <==  aux + L;
    outR <== -aux + R;
}

*/