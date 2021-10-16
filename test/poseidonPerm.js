const chai = require("chai");
const assert = chai.assert;

const poseidonPerm = require("../src/poseidonPerm.js");

describe("Poseidon permutation test", function () {
    it("Should match the reference implementation (sage poseidonperm_x5_254_3.sage)", async () => {
        const res2 = poseidonPerm([0, 1,2]);
        assert.equal("115cc0f5e7d690413df64c6b9662e9cf2a3617f2743245519e19607a4417189a", res2[0].toString(16));
        assert.equal("fca49b798923ab0239de1c9e7a4a9a2210312b6a2f616d18b5a87f9b628ae29", res2[1].toString(16));
        assert.equal("e7ae82e40091e63cbd4f16a6d16310b3729d4b6e138fcf54110e2867045a30c", res2[2].toString(16));
    });

    it("Should match the reference implementation (sage poseidonperm_x5_254_5.sage)", async () => {
        const res2 = poseidonPerm([0, 1,2,3,4]);
        assert.equal("299c867db6c1fdd79dcefa40e4510b9837e60ebb1ce0663dbaa525df65250465", res2[0].toString(16));
        assert.equal("1148aaef609aa338b27dafd89bb98862d8bb2b429aceac47d86206154ffe053d", res2[1].toString(16));
        assert.equal("24febb87fed7462e23f6665ff9a0111f4044c38ee1672c1ac6b0637d34f24907", res2[2].toString(16));
        assert.equal("eb08f6d809668a981c186beaf6110060707059576406b248e5d9cf6e78b3d3e", res2[3].toString(16));
        assert.equal("7748bc6877c9b82c8b98666ee9d0626ec7f5be4205f79ee8528ef1c4a376fc7", res2[4].toString(16));
    });
});
