const path = require("path");
const bigInt = require("big-integer");

const tester = require("circom").tester;

describe("Baby Jubjub twisted Edwards doubling test", function () {

    this.timeout(100000);

    let circuit;
    before( async() => {
        circuit = await tester(path.join(__dirname, "baby_edwards_dbl.test.circom"));
    });

    it("Should double the point (0,1)", async () => {

        const input={
            x: bigInt(0),
            y: bigInt(1)
        };

        const w = await circuit.calculateWitness(input, true);

        await circuit.assertOut(w, {xout: bigInt(0), yout: bigInt(1)});
    });

    it("Should double an arbitrary point", async () => {

        const input={
            x: bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
            y: bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475"),
        };

        const w = await circuit.calculateWitness(input, true);

        await circuit.assertOut(w, {
            xout: bigInt("6890855772600357754907169075114257697580319025794532037257385534741338397365"),
            yout: bigInt("4338620300185947561074059802482547481416142213883829469920100239455078257889")
        });
    });
});
