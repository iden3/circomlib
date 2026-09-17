const chai = require("chai");
const path = require("path");

const assert = chai.assert;

const wasm_tester = require("circom_tester").wasm;

const buildBabyjub = require("circomlibjs").buildBabyjub;
const buildEddsa = require("circomlibjs").buildEddsa;

// The subgroup templates rest on the curve having 8*r points with r prime, so that 8*p
// is in the subgroup of order r for every point p, and p is in that subgroup exactly when
// p = 8*q for some point q. The first tests pin those facts against circomlibjs before the
// circuits are exercised on them.
describe("Baby Jubjub subgroup tag", function () {
    this.timeout(200000);

    let bj, F, eddsa;
    let r, G, O, T2;               // subgroup order, generator, identity, the order-2 point
    let Pbad, Pbad2;               // points of the curve that are not in the subgroup
    let cirCheck, cirClear;

    const arr = (P) => [F.toObject(P[0]), F.toObject(P[1])];
    const eq = (P, Q) => F.eq(P[0], Q[0]) && F.eq(P[1], Q[1]);

    // Off-subgroup points are built as (subgroup point) + (0,-1). No square roots: the
    // wasm field's F.sqrt does not return for a non-residue, so it is not usable for
    // searching random points of the curve.

    async function shouldNotSatisfy(cir, input, why) {
        try {
            await cir.calculateWitness(input, true);
            assert(false, why);
        } catch (err) {
            assert(err.message.includes("Assert Failed"), err.message);
        }
    }

    before(async () => {
        bj = await buildBabyjub();
        F = bj.F;
        eddsa = await buildEddsa();
        r = bj.subOrder;
        G = bj.Base8;
        O = [F.zero, F.one];
        T2 = [F.zero, F.neg(F.one)];

        // (0,-1) has order 2, so adding it to a subgroup point leaves the subgroup
        Pbad = bj.addPoint(G, T2);
        Pbad2 = bj.addPoint(bj.mulPointEscalar(G, 3n), T2);

        cirCheck = await wasm_tester(path.join(__dirname, "circuits", "babysubgroupcheck_test.circom"));
        cirClear = await wasm_tester(path.join(__dirname, "circuits", "babysubgroupclear_test.circom"));
    });

    describe("the facts the templates rely on", function () {
        it("the curve has 8*r points", () => {
            assert.equal(bj.order, 8n * r);
        });

        it("(0,-1) is on the curve, has order 2, and is not in the subgroup", () => {
            assert(bj.inCurve(T2));
            assert(eq(bj.addPoint(T2, T2), O));
            assert(!bj.inSubgroup(T2));
        });

        it("the identity is in the subgroup", () => {
            assert(bj.inSubgroup(O));
        });

        it("G + (0,-1) is on the curve but not in the subgroup", () => {
            for (const P of [Pbad, Pbad2]) {
                assert(bj.inCurve(P));
                assert(!bj.inSubgroup(P));
                assert(!F.isZero(P[0]), "must not be caught by the x == 0 identity test");
            }
        });

        it("q = (8^-1 mod r) * G satisfies 8*q = G, the witness the check uses", () => {
            const inv8 = 2394026564107420727433200628387514462817212225638746351800188703329891451411n;
            assert.equal((8n * inv8) % r, 1n);
            const q = bj.mulPointEscalar(G, inv8);
            assert(bj.inCurve(q));
            assert(eq(bj.mulPointEscalar(q, 8n), G));
        });
    });

    describe("BabySubgroupCheck", function () {
        it("Should accept points of the subgroup and return them unchanged", async () => {
            for (const P of [G, bj.mulPointEscalar(G, 2n), bj.mulPointEscalar(G, r - 1n), O]) {
                const w = await cirCheck.calculateWitness({ p: arr(P) }, true);
                await cirCheck.checkConstraints(w);
                await cirCheck.assertOut(w, { "out.x": F.toObject(P[0]), "out.y": F.toObject(P[1]) }, true);
            }
        });

        it("Should not satisfy the order-2 point (0,-1)", async () => {
            await shouldNotSatisfy(cirCheck, { p: arr(T2) }, "(0,-1) is not in the subgroup");
        });

        it("Should not satisfy a point of the curve outside the subgroup", async () => {
            await shouldNotSatisfy(cirCheck, { p: arr(Pbad) }, "G + T is not in the subgroup");
        });
    });

    describe("BabySubgroupClear", function () {
        it("Should return 8*p, in the subgroup, for points in and out of the subgroup", async () => {
            for (const P of [G, Pbad, Pbad2, bj.mulPointEscalar(G, 7n)]) {
                const w = await cirClear.calculateWitness({ p: arr(P) }, true);
                await cirClear.checkConstraints(w);
                const P8 = bj.mulPointEscalar(P, 8n);
                assert(bj.inSubgroup(P8));
                await cirClear.assertOut(w, { "out.x": F.toObject(P8[0]), "out.y": F.toObject(P8[1]) }, true);
            }
        });

        it("Should send (0,-1) to the identity", async () => {
            const w = await cirClear.calculateWitness({ p: arr(T2) }, true);
            await cirClear.assertOut(w, { "out.x": 0, "out.y": 1 }, true);
        });

        it("Its output should pass BabySubgroupCheck", async () => {
            const P8 = bj.mulPointEscalar(Pbad, 8n);
            const w = await cirCheck.calculateWitness({ p: arr(P8) }, true);
            await cirCheck.checkConstraints(w);
        });
    });

    // The verifiers used to reject small-order public keys by testing (4*A).x == 0; they
    // now test (8*A).x == 0 on the cleared, tagged point. Same predicate, so the rejection
    // must still happen.
    describe("EdDSA verifiers still reject a public key of order 2", function () {
        function bits(buf) {
            const out = [];
            for (const byte of buf) for (let j = 0; j < 8; j++) out.push(BigInt((byte >> j) & 1));
            return out;
        }

        it("EdDSAPedersenVerifier", async () => {
            const cir = await wasm_tester(path.join(__dirname, "circuits", "eddsapedersen_test.circom"));
            const S = Buffer.alloc(32); S[0] = 1;
            const input = { A: bits(bj.packPoint(T2)), R8: bits(bj.packPoint(G)), S: bits(S), msg: new Array(80).fill(0n) };
            await shouldNotSatisfy(cir, input, "a public key of order 2 must be rejected");
        });

        it("EdDSAPoseidonVerifier, and only when enabled", async () => {
            const cir = await wasm_tester(path.join(__dirname, "circuits", "eddsaposeidon_test.circom"));
            const input = { enabled: 1, A: arr(T2), S: 1, R8: arr(G), M: 0 };
            await shouldNotSatisfy(cir, input, "a public key of order 2 must be rejected when enabled");
            const w = await cir.calculateWitness({ ...input, enabled: 0 }, true);
            await cir.checkConstraints(w);
        });
    });
});
