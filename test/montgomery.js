const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const Scalar = require("ffjavascript").Scalar;
const buildBabyjub = require("circomlibjs").buildBabyjub;

const assert = chai.assert;

describe("Montgomery test", function () {
    let babyJub;
    let Fr;
    let circuitE2M;
    let circuitM2E;
    let circuitMAdd;
    let circuitMDouble;

    let g;

    let mg, mg2, g2, g3, mg3;

    this.timeout(100000);


    before( async() => {
        babyJub = await buildBabyjub();
        Fr = babyJub.F;
        g = [
            Fr.e("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
            Fr.e("16950150798460657717958625567821834550301663161624707787222815936182638968203")
        ];

        circuitE2M = await wasm_tester(path.join(__dirname, "circuits", "edwards2montgomery.circom"));
        await circuitE2M.loadSymbols();
        circuitM2E = await wasm_tester(path.join(__dirname, "circuits", "montgomery2edwards.circom"));
        await circuitM2E.loadSymbols();
        circuitMAdd = await wasm_tester(path.join(__dirname, "circuits", "montgomeryadd.circom"));
        await circuitMAdd.loadSymbols();
        circuitMDouble = await wasm_tester(path.join(__dirname, "circuits", "montgomerydouble.circom"));
        await circuitMDouble.loadSymbols();
    });

    it("Convert Edwards to Montgomery and back again", async () => {
        let w, xout, yout;

        w = await circuitE2M.calculateWitness({ a: [Fr.toObject(g[0]), Fr.toObject(g[1])]}, true);

        xout = w[circuitE2M.symbols["main.out.x"].varIdx];
        yout = w[circuitE2M.symbols["main.out.y"].varIdx];

        mg = [xout, yout];

        w = await circuitM2E.calculateWitness({ a: [xout, yout]}, true);

        xout = w[circuitM2E.symbols["main.out.x"].varIdx];
        yout = w[circuitM2E.symbols["main.out.y"].varIdx];

        assert(Fr.eq(Fr.e(xout), g[0]));
        assert(Fr.eq(Fr.e(yout), g[1]));
    });
    it("Should double a point", async () => {
        let w, xout, yout;

        g2 = babyJub.addPoint(g,g);

        w = await circuitMDouble.calculateWitness({ a: mg}, true);

        xout = w[circuitE2M.symbols["main.out.x"].varIdx];
        yout = w[circuitE2M.symbols["main.out.y"].varIdx];

        mg2 = [xout, yout];

        w = await circuitM2E.calculateWitness({ a: mg2}, true);

        xout = w[circuitM2E.symbols["main.out.x"].varIdx];
        yout = w[circuitM2E.symbols["main.out.y"].varIdx];


        assert(Fr.eq(Fr.e(xout), g2[0]));
        assert(Fr.eq(Fr.e(yout), g2[1]));
    });
    it("Should add a point", async () => {
        let w, xout, yout;

        g3 = babyJub.addPoint(g,g2);

        w = await circuitMAdd.calculateWitness({ a: mg, b: mg2}, true);

        xout = w[circuitMAdd.symbols["main.out.x"].varIdx];
        yout = w[circuitMAdd.symbols["main.out.y"].varIdx];

        mg3 = [xout, yout];

        w = await circuitM2E.calculateWitness({ a: mg3}, true);

        xout = w[circuitM2E.symbols["main.out.x"].varIdx];
        yout = w[circuitM2E.symbols["main.out.y"].varIdx];

        assert(Fr.eq(Fr.e(xout), g3[0]));
        assert(Fr.eq(Fr.e(yout), g3[1]));
    });
});
