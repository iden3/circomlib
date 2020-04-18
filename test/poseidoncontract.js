const ganache = require("ganache-cli");
const Web3 = require("web3");
const chai = require("chai");
const poseidonGenContract = require("../src/poseidon_gencontract.js");
const Poseidon = require("../src/poseidon.js");

const assert = chai.assert;
const log = (msg) => { if (process.env.MOCHA_VERBOSE) console.log(msg); };

describe("Poseidon Smart contract test", function () {
    let testrpc;
    let web3;
    let poseidon6;
    let poseidon3;
    let accounts;
    this.timeout(100000);

    before(async () => {
        web3 = new Web3(ganache.provider(), null, { transactionConfirmationBlocks: 1 });
        accounts = await web3.eth.getAccounts();
    });

    it("Should deploy the contract", async () => {
        const C = new web3.eth.Contract(poseidonGenContract.abi);

        poseidon6 = await C.deploy({
            data: poseidonGenContract.createCode(6)
        }).send({
            gas: 2500000,
            from: accounts[0]
        });
        poseidon3 = await C.deploy({
            data: poseidonGenContract.createCode(3)
        }).send({
            gas: 2500000,
            from: accounts[0]
        });
    });

    it("Shold calculate the poseidon correctly t=6", async () => {

        const res = await poseidon6.methods.poseidon([1,2]).call();

        // console.log("Cir: " + bigInt(res.toString(16)).toString(16));

        const hash = Poseidon.createHash(6, 8, 57);

        const res2 = hash([1,2]);
        // console.log("Ref: " + bigInt(res2).toString(16));

        assert.equal(res.toString(), res2.toString());
    });
    it("Shold calculate the poseidon correctly t=3", async () => {

        const res = await poseidon3.methods.poseidon([1,2]).call();

        // console.log("Cir: " + bigInt(res.toString(16)).toString(16));

        const hash = Poseidon.createHash(3, 8, 57);

        const res2 = hash([1,2]);
        // console.log("Ref: " + bigInt(res2).toString(16));

        assert.equal(res.toString(), res2.toString());
    });

});

