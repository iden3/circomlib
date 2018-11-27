const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;


function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let circuitEMulAny;

    this.timeout(100000);

    let g = [
        snarkjs.bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
        snarkjs.bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475")
    ];

    before( async() => {
        const cirDefEMulAny = await compiler(path.join(__dirname, "circuits", "escalarmulany_test.circom"));
        circuitEMulAny = new snarkjs.Circuit(cirDefEMulAny);
        console.log("NConstrains Escalarmul any: " + circuitEMulAny.nConstraints);
    });

    it("Should generate Same escalar mul", async () => {

        const w = circuitEMulAny.calculateWitness({"e": 1, "p": g});

        assert(circuitEMulAny.checkWitness(w));

        const xout = w[circuitEMulAny.getSignalIdx("main.out[0]")];
        const yout = w[circuitEMulAny.getSignalIdx("main.out[1]")];

        assert(xout.equals(g[0]));
        assert(yout.equals(g[1]));
    });

    it("If multiply by order should return 0", async () => {

        const r = bigInt("2736030358979909402780800718157159386076813972158567259200215660948447373041");
        const w = circuitEMulAny.calculateWitness({"e": r, "p": g});

        assert(circuitEMulAny.checkWitness(w));

        const xout = w[circuitEMulAny.getSignalIdx("main.out[0]")];
        const yout = w[circuitEMulAny.getSignalIdx("main.out[1]")];

        assert(xout.equals(bigInt.zero));
        assert(yout.equals(bigInt.one));
    });

});

