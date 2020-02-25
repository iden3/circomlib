const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");
var blake2b = require('blake2b');

const poseidon = require("../src/poseidon.js");

const assert = chai.assert;

describe("Blake2b version test", function() {
    it("Should give the expected output for blake2b version", async () => {
        var output = new Uint8Array(32);
        var input = Buffer.from('poseidon_constants');
        h = blake2b(output.length).update(input).digest('hex')
        assert.equal('e57ba154fb2c47811dc1a2369b27e25a44915b4e4ece4eb8ec74850cb78e01b1', h);
    });
});

describe("Poseidon Circuit test", function () {
    let circuit6;
    let circuit3;

    this.timeout(100000);

    before( async () => {
        const cirDef6 = await compiler(path.join(__dirname, "circuits", "poseidon6_test.circom"));
        circuit6 = new snarkjs.Circuit(cirDef6);
        console.log("Poseidon6 constraints: " + circuit6.nConstraints);
        const cirDef3 = await compiler(path.join(__dirname, "circuits", "poseidon3_test.circom"));
        circuit3 = new snarkjs.Circuit(cirDef3);
        console.log("Poseidon3 constraints: " + circuit3.nConstraints);
    });

    it("Should check constrain of hash([1, 2]) t=6", async () => {
        const w = circuit6.calculateWitness({inputs: [1, 2]});

        const res = w[circuit6.getSignalIdx("main.out")];

        const hash = poseidon.createHash(6, 8, 57);

        const res2 = hash([1,2]);
        assert.equal("12242166908188651009877250812424843524687801523336557272219921456462821518061", res2.toString());
        assert.equal(res.toString(), res2.toString());
        assert(circuit6.checkWitness(w));
    });

    it("Should check constrain of hash([3, 4]) t=6", async () => {
        const w = circuit6.calculateWitness({inputs: [3, 4]});

        const res = w[circuit6.getSignalIdx("main.out")];

        const hash = poseidon.createHash(6, 8, 57);

        const res2 = hash([3, 4]);
        assert.equal("17185195740979599334254027721507328033796809509313949281114643312710535000993", res2.toString());

        assert.equal(res.toString(), res2.toString());

        assert(circuit6.checkWitness(w));
    });


    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = circuit3.calculateWitness({inputs: [1, 2]});

        const res = w[circuit3.getSignalIdx("main.out")];

        const hash = poseidon.createHash(3, 8, 57);

        const res2 = hash([1,2]);
        assert.equal("2104035019328376391822106787753454168168617545136592089411833517434990977743", res2.toString());
        assert.equal(res.toString(), res2.toString());
        assert(circuit3.checkWitness(w));
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = circuit3.calculateWitness({inputs: [3, 4]});

        const res = w[circuit3.getSignalIdx("main.out")];

        const hash = poseidon.createHash(3, 8, 57);

        const res2 = hash([3, 4]);
        assert.equal("12456141564250880945411182508630957604732712316993112736876413121277158512223", res2.toString());

        assert.equal(res.toString(), res2.toString());

        assert(circuit3.checkWitness(w));
    });
});
