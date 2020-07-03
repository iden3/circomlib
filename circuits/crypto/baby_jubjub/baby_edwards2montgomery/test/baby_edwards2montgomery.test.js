const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

const assert = chai.assert;

describe("Baby Jubjub Edwards to Montgomery test", function () {
    let circuitE2M;

    // Generator
    let g = [
        bigInt("995203441582195749578291179787384436505546430278305826713579947235728471134"),
        bigInt("5472060717959818805561601436314318772137091100104008585924551046643952123905")
    ];

    let mg = [
        bigInt("7"),
        bigInt("4258727773875940690362607550498304598101071202821725296872974770776423442226")
    ];

    // Arbitrary point
    let p = [
        bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
        bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
    ];

    let mp = [
        bigInt("7117928050407583618111176421555214756675765419608405867398403713213306743542"),
        bigInt("14577268218881899420966779687690205425227431577728659819975198491127179315626")
    ];
    
    this.timeout(100000);
    before( async() => {
        circuitE2M = await tester(path.join(__dirname, "baby_edwards2montgomery.test.circom"));
        await circuitE2M.loadSymbols();

    });

    it("Should convert the generator point of Edwards to Montgomery", async () => {
        let w, xout, yout;

        w = await circuitE2M.calculateWitness({ in: g}, true);

        xout = w[circuitE2M.symbols["main.out[0]"].varIdx];
        yout = w[circuitE2M.symbols["main.out[1]"].varIdx];

        assert(xout.equals(mg[0]));
        assert(yout.equals(mg[1]));
    });

    it("Should convert an arbitrary point in Edwards to Montgomery", async () => {
        let w, xout, yout;

        w = await circuitE2M.calculateWitness({ in: p}, true);

        xout = w[circuitE2M.symbols["main.out[0]"].varIdx];
        yout = w[circuitE2M.symbols["main.out[1]"].varIdx];

        assert(xout.equals(mp[0]));
        assert(yout.equals(mp[1]));

    });

});
