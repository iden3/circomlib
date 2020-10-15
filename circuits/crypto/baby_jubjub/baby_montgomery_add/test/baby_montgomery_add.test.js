const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

const assert = chai.assert;

describe("Montgomery addition test", function () {
    let circuitMAdd;

    let P = [bigInt("7117928050407583618111176421555214756675765419608405867398403713213306743542"),
            bigInt("14577268218881899420966779687690205425227431577728659819975198491127179315626")];

    let Q = [bigInt("7"), bigInt("4258727773875940690362607550498304598101071202821725296872974770776423442226")];
    
    // P+Q
    let PQ = [bigInt("17550680835621450423322001654411905164609268049693794423423767669392150006224"), 
             bigInt("21088170181011345210160751119080317996856861517940411712689925366040873499197")];

    this.timeout(100000);

    before( async() => {
        circuitMAdd = await tester(path.join(__dirname, "baby_montgomery_add.test.circom"));
        await circuitMAdd.loadSymbols();
    });

    it("Should add two points", async () => {
        let w, xout, yout;

        w = await circuitMAdd.calculateWitness({ in1: P, in2: Q}, true);

        xout = w[circuitMAdd.symbols["main.out[0]"].varIdx];
        yout = w[circuitMAdd.symbols["main.out[1]"].varIdx];

        assert(xout.equals(PQ[0]));
        assert(yout.equals(PQ[1]));
    });
});
