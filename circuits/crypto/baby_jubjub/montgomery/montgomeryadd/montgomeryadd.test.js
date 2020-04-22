const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

const assert = chai.assert;

describe("Montgomery addition test", function () {
    let circuitMAdd;

    // Arbitrary point p
    let p = [
        bigInt("7117928050407583618111176421555214756675765419608405867398403713213306743542"),
        bigInt("14577268218881899420966779687690205425227431577728659819975198491127179315626")
    ];

    // TODO:
    // Arbitrary point q
    let q = [
        bigInt("0"),
        bigInt("1")
    ];
 
    // TODO:    
    // Point q+q
    let pq = [
        bigInt("0"),
        bigInt("1")
    ];

    this.timeout(100000);

    before( async() => {
        circuitMAdd = await tester(path.join(__dirname, "montgomeryadd_test.circom"));
        await circuitMAdd.loadSymbols();
    });

    it("Should add two abitrary points", async () => {
        let w, xout, yout;

        w = await circuitMAdd.calculateWitness({ in1: p, in2: q}, true);

        xout = w[circuitMAdd.symbols["main.out[0]"].varIdx];
        yout = w[circuitMAdd.symbols["main.out[1]"].varIdx];

// TODO:
//        assert(xout.equals(pq[0]));
//        assert(yout.equals(pq[1]));
    });

    // TODO: Test that fails when origin is an input?
});
