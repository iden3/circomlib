const chai = require("chai");
const path = require("path");
const bigInt = require("big-integer");
const tester = require("circom").tester;

const assert = chai.assert;

describe("Baby Jubjub Montgomery to Edwards test", function () {

    let circuitM2E;

    // Generator
    let g = [
        bigInt("7"),
        bigInt("4258727773875940690362607550498304598101071202821725296872974770776423442226")
    ];

    let eg = [
        bigInt("995203441582195749578291179787384436505546430278305826713579947235728471134"),
        bigInt("5472060717959818805561601436314318772137091100104008585924551046643952123905")
    ];

    // Arbitrary point
    let p = [
        bigInt("7117928050407583618111176421555214756675765419608405867398403713213306743542"),
        bigInt("14577268218881899420966779687690205425227431577728659819975198491127179315626")
    ];

    let ep = [
        bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
        bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
    ];
    
    this.timeout(100000);
    before( async() => {
        circuitM2E = await tester(path.join(__dirname, "baby_montgomery2edwards.test.circom"));
        await circuitM2E.loadSymbols();
    });

    it("Convert the generator point of Montgomery to Edwards", async () => {
        let w, xout, yout;

        w = await circuitM2E.calculateWitness({ in: g}, true);

        xout = w[circuitM2E.symbols["main.out[0]"].varIdx];
        yout = w[circuitM2E.symbols["main.out[1]"].varIdx];

        assert(xout.equals(eg[0]));
        assert(yout.equals(eg[1]));

    });

    it("Convert an arbitrary point in Montgomery to Edwards", async () => {
        let w, xout, yout;

        w = await circuitM2E.calculateWitness({ in: p}, true);

        xout = w[circuitM2E.symbols["main.out[0]"].varIdx];
        yout = w[circuitM2E.symbols["main.out[1]"].varIdx];

        assert(xout.equals(ep[0]));
        assert(yout.equals(ep[1]));
    });

});
