const chai = require("chai");
const path = require("path");
const tester = require("circom").tester;

const poseidon = require("../src/poseidon.js");

const assert = chai.assert;

describe("Poseidon Circuit test", function () {
    let circuit6;
    let circuit3;

    this.timeout(100000);

    before( async () => {
        circuit6 = await tester(path.join(__dirname, "circuits", "poseidon6_test.circom"));
        circuit3 = await tester(path.join(__dirname, "circuits", "poseidon3_test.circom"));
    });

    it("Should check constrain of hash([1, 2]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [1, 2, 0,0,0]}, true);

        const res2 = poseidon([1,2,0,0,0]);
        assert.equal("3975478831357328722254985704342968745327876719981393787143845259590563829094", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [3, 4,5,10,23]});

        const res2 = poseidon([3, 4,5,10,23]);

        assert.equal("18540626624821144952552691894137986276337186174352554475896834101336254024067", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });


    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]});

        const res2 = poseidon([1,2]);
        assert.equal("17117985411748610629288516079940078114952304104811071254131751175361957805920", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [3, 4]});

        const res2 = poseidon([3, 4]);
        assert.equal("21867347236198497199818917118739170715216974132230970409806500217655788551452", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });
});
