const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");

const compiler = require("circom");
const babyJub = require("../src/babyjub.js");
const ecvrf = require("../src/ecvrfposeidon.js");
const snarkjs = require("snarkjs");

const assert = chai.assert;

function bitify(x, n) {
    return Array(n).fill(0).map((_,i) => (x>>BigInt(i))&1n );
}

describe("ECVRF test", () => {
    it("compute proof and verify it", () => {

        const alpha = bigInt("1934753913053");
        const x = bigInt("324583502347240341734");
        const Q = babyJub.mulPointEscalar(babyJub.Base8, x);

        const proof = ecvrf.proof(x, alpha);
        assert(ecvrf.verify(Q[0], alpha, ...proof));
    });

    it("test circuit for ecvrf", async () => {

        const alpha = bigInt("1934753913053");
        const x = bigInt("324583502347240341734");
        const Q = babyJub.mulPointEscalar(babyJub.Base8, x);

        const [Gamma, c, s] = ecvrf.proof(x, alpha);

        const cirDef = await compiler(path.join(__dirname, "circuits", "ecvrfposeidon_test.circom"));
        const circuit = new snarkjs.Circuit(cirDef);

        const input = {
            Q:Q.map(e=>e.value), 
            Gamma: Gamma.map(e=>e.value),
            c: bitify(c.value, 254),
            s: bitify(s.value, 251),
            alpha: alpha.value
        };

        const witness = circuit.calculateWitness(input);

        assert(witness[0]==1n, "ecvrf result should be valid");
      
    }).timeout(6000000)
});
