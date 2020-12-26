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
        assert.equal("1944517543886089121158331594914426541694339782056411886233994349799551050705", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=6", async () => {
        const w = await circuit6.calculateWitness({inputs: [3, 4,5,10,23]});

        const res2 = poseidon([3, 4,5,10,23]);

        assert.equal("15043529598202765311255531083507141602555136943545139099151157943137780370931", res2.toString());
        await circuit6.assertOut(w, {out : res2});
        await circuit6.checkConstraints(w);
    });


    it("Should check constrain of hash([1, 2]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [1, 2]});

        const res2 = poseidon([1,2]);
        assert.equal("11309872961022349216464221841186646423561022368884850929991258903497301047946", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });

    it("Should check constrain of hash([3, 4]) t=3", async () => {
        const w = await circuit3.calculateWitness({inputs: [3, 4]});

        const res2 = poseidon([3, 4]);
        assert.equal("5452722186384045185233705092171776011224530037417547968760104202263491217182", res2.toString());
        await circuit3.assertOut(w, {out : res2});
        await circuit3.checkConstraints(w);
    });
});
