const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const bigInt = require("big-integer");

const compiler = require("circom");
const babyJub = require("../src/babyjub.js");

const assert = chai.assert;

describe("Shallue-Woestijne-Ulas point picker test", () => {
    it("Should select a point on the curve in the circuit", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "swuselect_test.circom"));
        const circuit = new snarkjs.Circuit(cirDef);
        const witness = circuit.calculateWitness({ "in": "8" });
        assert(babyJub.inCurve(witness.slice(1,3).map(x=>bigInt(x))));

    });

    it("Should select a point on the curve in js script", async () => {

        const t = bigInt(8);
        const point = babyJub.SWUSelect(t);
        assert(babyJub.inCurve(point));

    });
});
