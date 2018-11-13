const chai = require("chai");
const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;

const babyJub = require("../src/babyjub.js");

const PBASE =
    [
        [   bigInt( "6842263847932328569390632736104801120816056295876316310227967232893658007436"),
            bigInt("10520112236148895828506510766039255961372323270202387671483666293012156799229")],
        [   bigInt( "7512553369533424708326990019377586455744651641787163924108944444109352325495"),
            bigInt(  "242060483180498555826438209654403949979206323274480625257315595534333598496")],
        [   bigInt(  "480315709862415282411588615813248553518720286084247594626493599605932342246"),
            bigInt("15016559215090999873142530067666085992648246670781771102893391410239675444873")],
        [   bigInt( "8311398801616893527636419786153024398643144699386228070202625261657263599049"),
            bigInt("11125962584728296601438821974884453267303385157860713577195820780853779600315")],
        [   bigInt( "1924118814882677827825936037840538695314492559747259292440881566152665343441"),
            bigInt("17232376423406964731689089286495480735310130852288107159412732879983310795144")]
    ];

describe("Double Pedersen test", function() {
    let circuit;
    this.timeout(100000);
    before( async() => {
        const cirDef = await compiler(path.join(__dirname, "circuits", "pedersen_test.circom"));

        circuit = new snarkjs.Circuit(cirDef);

        console.log("NConstrains: " + circuit.nConstraints);
    });
    it("Should pedersen at zero", async () => {

        let w, xout, yout;

        w = circuit.calculateWitness({ in: ["0", "0"]});

        xout = w[circuit.getSignalIdx("main.out[0]")];
        yout = w[circuit.getSignalIdx("main.out[1]")];

        assert(xout.equals("0"));
        assert(yout.equals("1"));
    });
    it("Should pedersen at one first generator", async () => {
        let w, xout, yout;

        w = circuit.calculateWitness({ in: ["1", "0"]});

        xout = bigInt(w[circuit.getSignalIdx("main.out[0]")]);
        yout = bigInt(w[circuit.getSignalIdx("main.out[1]")]);

        assert(xout.equals(PBASE[0][0]));
        assert(yout.equals(PBASE[0][1]));
    });
    it("Should pedersen at one second generator", async () => {
        let w, xout, yout;

        w = circuit.calculateWitness({ in: ["0", "1"]});

        xout = w[circuit.getSignalIdx("main.out[0]")];
        yout = w[circuit.getSignalIdx("main.out[1]")];

        assert(xout.equals(PBASE[1][0]));
        assert(yout.equals(PBASE[1][1]));

    });
    it("Should pedersen at mixed generators", async () => {
        let w, xout, yout;
        w = circuit.calculateWitness({ in: ["3", "7"]});

        xout = w[circuit.getSignalIdx("main.out[0]")];
        yout = w[circuit.getSignalIdx("main.out[1]")];


        const r = babyJub.addPoint(
            babyJub.mulPointEscalar(PBASE[0], 3),
            babyJub.mulPointEscalar(PBASE[1], 7)
        );

        assert(xout.equals(r[0]));
        assert(yout.equals(r[1]));

    });
    it("Should pedersen all ones", async () => {
        let w, xout, yout;

        const allOnes = bigInt("1").shl(253).sub(bigInt("1"));
        w = circuit.calculateWitness({ in: [allOnes, allOnes]});

        xout = w[circuit.getSignalIdx("main.out[0]")];
        yout = w[circuit.getSignalIdx("main.out[1]")];

        const r2 = babyJub.addPoint(
            babyJub.mulPointEscalar(PBASE[0], allOnes),
            babyJub.mulPointEscalar(PBASE[1], allOnes)
        );

        assert(xout.equals(r2[0]));
        assert(yout.equals(r2[1]));
    });
});
