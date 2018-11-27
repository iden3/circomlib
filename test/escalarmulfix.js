const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");
const babyjub = require("../src/babyjub");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;


function print(circuit, w, s) {
    console.log(s + ": " + w[circuit.getSignalIdx(s)]);
}

describe("Escalarmul test", function () {
    let circuit;

    this.timeout(100000);

    before( async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "escalarmulfix_test.circom"));
        circuit = new snarkjs.Circuit(cirDef);
        console.log("NConstrains Escalarmul fix: " + circuit.nConstraints);
    });

    it("Should generate Same escalar mul", async () => {

        const w = circuit.calculateWitness({"e": 0});

        assert(circuit.checkWitness(w));

        const xout = w[circuit.getSignalIdx("main.out[0]")];
        const yout = w[circuit.getSignalIdx("main.out[1]")];

        assert(xout.equals(0));
        assert(yout.equals(1));
    });

    it("Should generate Same escalar mul", async () => {

        const w = circuit.calculateWitness({"e": 1});

        assert(circuit.checkWitness(w));

        const xout = w[circuit.getSignalIdx("main.out[0]")];
        const yout = w[circuit.getSignalIdx("main.out[1]")];

        assert(xout.equals(babyjub.Base8[0]));
        assert(yout.equals(babyjub.Base8[1]));
    });

    it("If multiply by order should return 0", async () => {

        const w = circuit.calculateWitness({"e": babyjub.subOrder });

        assert(circuit.checkWitness(w));

        const xout = w[circuit.getSignalIdx("main.out[0]")];
        const yout = w[circuit.getSignalIdx("main.out[1]")];

        assert(xout.equals(bigInt.zero));
        assert(yout.equals(bigInt.one));
    });

});

