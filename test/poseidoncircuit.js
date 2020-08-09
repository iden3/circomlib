const chai = require("chai");
const path = require("path");
const tester = require("circom").tester;

const poseidon = require("../src/poseidon.js");

const assert = chai.assert;

describe("Poseidon Circuit test", function () {
    let circuit2;
    let circuit4;

    this.timeout(100000);

    before(async () => {
        circuit2 = await tester(path.join(__dirname, "circuits", "poseidon2_test.circom"));
        circuit4 = await tester(path.join(__dirname, "circuits", "poseidon4_test.circom"));
    });

    it("Should check constrain of hash([1, 2])", async () => {
        const hash = poseidon([1, 2]);
        assert.equal("17117985411748610629288516079940078114952304104811071254131751175361957805920", hash.toString());
        const w = await circuit2.calculateWitness({inputs: [1, 2]}, true);
        await circuit2.assertOut(w, {out : hash});
        await circuit2.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4])", async () => {
        const hash = poseidon([3, 4]);
        assert.equal("21867347236198497199818917118739170715216974132230970409806500217655788551452", hash.toString());
        const w = await circuit2.calculateWitness({inputs: [3, 4]});
        await circuit2.assertOut(w, {out : hash});
        await circuit2.checkConstraints(w);
    });


    it("Should check constrain of hash([1, 2, 3, 4])", async () => {
        const hash = poseidon([1, 2, 3, 4]);
        assert.equal("10501812514110530158422365608831771203648472822841727510887411206067265790462", hash.toString());
        const w = await circuit4.calculateWitness({inputs: [1, 2, 3, 4]});
        await circuit4.assertOut(w, {out : hash});
        await circuit4.checkConstraints(w);
    });

    it("Should check constrain of hash([5, 6, 7, 8])", async () => {
        const hash = poseidon([5, 6, 7, 8]);
        assert.equal("20761996991478317428195238015626872345373101531750069996451149877836620406299", hash.toString());
        const w = await circuit4.calculateWitness({inputs: [5, 6, 7, 8]});
        await circuit4.assertOut(w, {out : hash});
        await circuit4.checkConstraints(w);
    });
});
