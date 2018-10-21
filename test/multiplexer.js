const chai = require("chai");
const path = require("path");
const zkSnark = require("zksnark");
const compiler = require("circom");

const assert = chai.assert;

const bigInt = require("big-integer");


describe("Mux4 test", () => {
    it("Should create a constant multiplexer", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "mux4_1.circom"));

//        console.log(JSON.stringify(cirDef, null, 1));

//        assert.equal(cirDef.nVars, 2);

        const circuit = new zkSnark.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);

        for (i=0; i<16; i++) {
            const w = circuit.calculateWitness({ "selector": zkSnark.bigInt(i).toString() });

            assert(w[0].equals(zkSnark.bigInt(1)));

            console.log(i + " -> " + w[circuit.getSignalIdx("main.out")].toString());
//            assert(w[circuit.getSignalIdx("main.out")].equals(zkSnark.bigInt("100").add(zkSnark.bigInt(i))));
        }
    });
});
