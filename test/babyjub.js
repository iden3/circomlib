const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const assert = chai.assert;

const bigInt = require("big-integer");


describe("Baby Jub test", () => {
    it("Should add point (0,1) and (0,1)", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "babyadd_tester.circom"));

//        console.log(JSON.stringify(cirDef, null, 1));

//        assert.equal(cirDef.nVars, 2);

        const circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);

        const input={
            x1: snarkjs.bigInt(0),
            y1: snarkjs.bigInt(1),
            x2: snarkjs.bigInt(0),
            y2: snarkjs.bigInt(1)
        }

        const w = circuit.calculateWitness(input);

        const xout = w[circuit.getSignalIdx("main.xout")];
        const yout = w[circuit.getSignalIdx("main.yout")];

        assert(xout.equals(0));
        assert(yout.equals(1));
    });

    it("Should add 2 same numbers", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "babyadd_tester.circom"));

//        console.log(JSON.stringify(cirDef, null, 1));

//        assert.equal(cirDef.nVars, 2);

        const circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);

        const input={
            x1: snarkjs.bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y1: snarkjs.bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475"),
            x2: snarkjs.bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y2: snarkjs.bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475")
        }

        const w = circuit.calculateWitness(input);

        const xout = w[circuit.getSignalIdx("main.xout")];
        const yout = w[circuit.getSignalIdx("main.yout")];

        assert(xout.equals(snarkjs.bigInt("6890855772600357754907169075114257697580319025794532037257385534741338397365")));
        assert(yout.equals(snarkjs.bigInt("4338620300185947561074059802482547481416142213883829469920100239455078257889")));
    });

    it("Should add 2 different numbers", async () => {

        const cirDef = await compiler(path.join(__dirname, "circuits", "babyadd_tester.circom"));

//        console.log(JSON.stringify(cirDef, null, 1));

//        assert.equal(cirDef.nVars, 2);

        const circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);

        const input={
            x1: snarkjs.bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y1: snarkjs.bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475"),
            x2: snarkjs.bigInt("16540640123574156134436876038791482806971768689494387082833631921987005038935"),
            y2: snarkjs.bigInt("20819045374670962167435360035096875258406992893633759881276124905556507972311")
        }

        const w = circuit.calculateWitness(input);

        const xout = w[circuit.getSignalIdx("main.xout")];
        const yout = w[circuit.getSignalIdx("main.yout")];

        console.log(xout.toString());
        console.log(yout.toString());

        assert(xout.equals(snarkjs.bigInt("7916061937171219682591368294088513039687205273691143098332585753343424131937")));
        assert(yout.equals(snarkjs.bigInt("14035240266687799601661095864649209771790948434046947201833777492504781204499")));
    });
});
