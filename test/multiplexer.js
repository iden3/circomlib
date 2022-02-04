const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

describe("Mux6 test", function() {
    this.timeout(100000);
    it("Should create a constant multiplexer 6", async () => {

        const circuit = await wasm_tester(path.join(__dirname, "circuits", "mux6_1.circom"));

        const ct64 = [
            Fr.e("1230"),
            Fr.e("4560"),
            Fr.e("7890"),
            Fr.e("0120"),
            Fr.e("1110"),
            Fr.e("2220"),
            Fr.e("3330"),
            Fr.e("45460"),
            Fr.e("1345230"),
            Fr.e("443560"),
            Fr.e("156230"),
            Fr.e("45660"),
            Fr.e("12230"),
            Fr.e("45460"),
            Fr.e("42560"),
            Fr.e("44560"),

            Fr.e("1231"),
            Fr.e("4561"),
            Fr.e("7891"),
            Fr.e("0121"),
            Fr.e("1111"),
            Fr.e("2221"),
            Fr.e("3331"),
            Fr.e("45461"),
            Fr.e("1345231"),
            Fr.e("443561"),
            Fr.e("156231"),
            Fr.e("45661"),
            Fr.e("12231"),
            Fr.e("45461"),
            Fr.e("42561"),
            Fr.e("44561"),

            Fr.e("1232"),
            Fr.e("4562"),
            Fr.e("7892"),
            Fr.e("0122"),
            Fr.e("1112"),
            Fr.e("2222"),
            Fr.e("3332"),
            Fr.e("45462"),
            Fr.e("1345232"),
            Fr.e("443562"),
            Fr.e("156232"),
            Fr.e("45662"),
            Fr.e("12232"),
            Fr.e("45462"),
            Fr.e("42562"),
            Fr.e("44562"),

	    Fr.e("1233"),
            Fr.e("4563"),
            Fr.e("7893"),
            Fr.e("0123"),
            Fr.e("1113"),
            Fr.e("2223"),
            Fr.e("3333"),
            Fr.e("45463"),
            Fr.e("1345233"),
            Fr.e("443563"),
            Fr.e("156233"),
            Fr.e("45663"),
            Fr.e("12233"),
            Fr.e("45463"),
            Fr.e("42563"),
            Fr.e("44563")
        ];

        for (let i=0; i<64; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct64[i]});
        }
    });

    it("Should create a constant multiplexer 4", async () => {

        const circuit = await wasm_tester(path.join(__dirname, "circuits", "mux4_1.circom"));

        const ct16 = [
            Fr.e("123"),
            Fr.e("456"),
            Fr.e("789"),
            Fr.e("012"),
            Fr.e("111"),
            Fr.e("222"),
            Fr.e("333"),
            Fr.e("4546"),
            Fr.e("134523"),
            Fr.e("44356"),
            Fr.e("15623"),
            Fr.e("4566"),
            Fr.e("1223"),
            Fr.e("4546"),
            Fr.e("4256"),
            Fr.e("4456")
        ];

        for (let i=0; i<16; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct16[i]});
        }
    });

    it("Should create a constant multiplexer 3", async () => {

        const circuit = await wasm_tester(path.join(__dirname, "circuits", "mux3_1.circom"));

        const ct8 = [
            Fr.e("37"),
            Fr.e("47"),
            Fr.e("53"),
            Fr.e("71"),
            Fr.e("89"),
            Fr.e("107"),
            Fr.e("163"),
            Fr.e("191")
        ];

        for (let i=0; i<8; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct8[i]});
        }
    });
    it("Should create a constant multiplexer 2", async () => {

        const circuit = await wasm_tester(path.join(__dirname, "circuits", "mux2_1.circom"));

        const ct4 = [
            Fr.e("37"),
            Fr.e("47"),
            Fr.e("53"),
            Fr.e("71"),
        ];

        for (let i=0; i<4; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct4[i]});
        }
    });
    it("Should create a constant multiplexer 1", async () => {

        const circuit = await wasm_tester(path.join(__dirname, "circuits", "mux1_1.circom"));

        const ct2 = [
            Fr.e("37"),
            Fr.e("47"),
        ];

        for (let i=0; i<2; i++) {
            const w = await circuit.calculateWitness({ "selector": i }, true);

            await circuit.checkConstraints(w);

            await circuit.assertOut(w, {out: ct2[i]});
        }
    });
});
