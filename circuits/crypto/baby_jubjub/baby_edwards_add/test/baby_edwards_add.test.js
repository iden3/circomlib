const path = require("path");
const bigInt = require("big-integer");

const tester = require("circom").tester;

describe("Baby Jubjub twisted Edwards addition test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "baby_edwards_add.test.circom"));
    });

    it("Should add the points (0,1) and (0,1)", async () => {

        const input={
            x1: bigInt(0),
            y1: bigInt(1),
            x2: bigInt(0),
            y2: bigInt(1)
        };

        const w = await circuit.calculateWitness(input, true);

        await circuit.assertOut(w, {xout: bigInt(0), yout: bigInt(1)});
    });

    it("Should add the 2 same points", async () => {

        const input={
            x1: bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y1: bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475"),
            x2: bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y2: bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475")
        };

        const w = await circuit.calculateWitness(input, true);

        await circuit.assertOut(w, {
            xout: bigInt("6890855772600357754907169075114257697580319025794532037257385534741338397365"),
            yout: bigInt("4338620300185947561074059802482547481416142213883829469920100239455078257889")
        });
    });

    it("Should add 2 different points", async () => {

        const input={
            x1: bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y1: bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475"),
            x2: bigInt("16540640123574156134436876038791482806971768689494387082833631921987005038935"),
            y2: bigInt("20819045374670962167435360035096875258406992893633759881276124905556507972311")
        };

        const w = await circuit.calculateWitness(input, true);

        await circuit.assertOut(w, {
            xout: bigInt("7916061937171219682591368294088513039687205273691143098332585753343424131937"),
            yout: bigInt("14035240266687799601661095864649209771790948434046947201833777492504781204499")
        });
    });
});
