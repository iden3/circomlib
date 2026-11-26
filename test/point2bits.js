const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const buildBabyJub = require("circomlibjs").buildBabyjub;

const babyJub = require("circomlibjs").babyjub;


describe("Point 2 bits test", function() {
    let babyJub;
    let F;
    let circuit;
    let circuitUnchecked;
    this.timeout(100000);
    before( async() => {
        babyJub = await buildBabyJub();
        F = babyJub.F;

        circuit = await wasm_tester(path.join(__dirname, "circuits", "pointbits_loopback.circom"));
        circuitUnchecked = await wasm_tester(path.join(__dirname, "circuits", "bits2point_unchecked_test.circom"));
    });

    // Bits of y (least significant first) and the sign of x, as Bits2Point_Strict reads them.
    function encode(P) {
        const x = F.toObject(P[0]);
        const y = F.toObject(P[1]);
        const half = (F.p - 1n) / 2n;
        const bits = [];
        for (let i = 0; i < 254; i++) bits.push((y >> BigInt(i)) & 1n);
        return { y: bits, signX: x > half ? 1n : 0n };
    }

    it("Should do the both convertions for 8Base", async () => {
        const w = await circuit.calculateWitness({ in: [F.toObject(babyJub.Base8[0]), F.toObject(babyJub.Base8[1])]}, true);

        await circuit.checkConstraints(w);
    });
    it("Should do the both convertions for Zero point", async () => {
        const w = await circuit.calculateWitness({ in: [0, 1]}, true);

        await circuit.checkConstraints(w);
    });
    it("Should decode binary bits passed in an unchecked BinaryPoint", async () => {
        const w = await circuitUnchecked.calculateWitness(encode(babyJub.Base8), true);
        await circuitUnchecked.checkConstraints(w);
        await circuitUnchecked.assertOut(w, { out: [F.toObject(babyJub.Base8[0]), F.toObject(babyJub.Base8[1])] });
    });
    it("Should reject a non-binary encoding of the same y", async () => {
        const input = encode(babyJub.Base8);
        // Bits (0, 1) at positions i, i+1 and (2, 0) give the same y, but 2 is not a bit.
        const i = input.y.findIndex((b, k) => k < 253 && b === 0n && input.y[k+1] === 1n);
        input.y[i] = 2n;
        input.y[i+1] = 0n;
        let accepted = false;
        try {
            await circuitUnchecked.calculateWitness(input, true);
            accepted = true;
        } catch (err) {
            if (!err.message.includes("Assert Failed")) throw err;
        }
        if (accepted) throw new Error("a non-binary encoding was accepted");
    });
});
