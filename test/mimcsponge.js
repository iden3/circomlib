const chai = require("chai");
const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;

const w3utils = require("web3-utils");
const F = bn128.Fr;

const mimcjs = require("../src/mimcsponge.js");

const assert = chai.assert;

describe("MiMC Sponge test", function () {
	let xL, xR, key, keyW, mult

	before(async () => {
		xL = F.affine(bigInt(w3utils.toBN(w3utils.keccak256("left")).toString()))
		xR = F.affine(bigInt(w3utils.toBN(w3utils.keccak256("right")).toString()))
		key = F.affine(bigInt(w3utils.toBN(w3utils.keccak256("key")).toString()))
		keyW = F.affine(bigInt(w3utils.toBN(w3utils.keccak256("keyW")).toString()))
	})

	it("Should encrypt and decrypt with same key", async () => {
		const ct = mimcjs.encrypt(xL, xR, key)
		const pt = mimcjs.decrypt(ct.xL, ct.xR, key)
		assert.equal(xL.toString(), pt.xL.toString())
		assert.equal(xR.toString(), pt.xR.toString())
	})

	it("Should fail to encrypt and decrypt with different keys", async () => {
		const ct = mimcjs.encrypt(xL, xR, key)
		const pt = mimcjs.decrypt(ct.xL, ct.xR, keyW)
		assert.notEqual(xL.toString(), pt.xL.toString())
		assert.notEqual(xR.toString(), pt.xR.toString())
	})
});

