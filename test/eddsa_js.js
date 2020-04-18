const chai = require("chai");

const eddsa = require("../src/eddsa.js");
const babyJub = require("../src/babyjub.js");

const assert = chai.assert;

const utils = require("ffjavascript").utils;

describe("EdDSA js test", function () {

    this.timeout(100000);

    it("Sign (using Mimc7) a single 10 bytes from 0 to 9", () => {
        const msgBuf = Buffer.from("00010203040506070809", "hex");
        const msg = utils.leBuff2int(msgBuf);

        //  const prvKey = crypto.randomBytes(32);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        assert.equal(pubKey[0].toString(),
            "17579234973106307986399040784563986669343100608865726413246909559198451825625");
        assert.equal(pubKey[1].toString(),
            "21581828029826859845363968476425861244058376747493285816141526544272562145486");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signMiMC(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "12672422877531089818651367820728973438446851190471722610781936061829103362897");
        assert.equal(signature.R8[1].toString(),
            "12052234579439634484237590306927118446073354173341433290934144373261241958718");
        assert.equal(signature.S.toString(),
            "1582013862333331285840015273849085014739146294568319205499642618291614907374");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "3e417cd811f9c9c545a680b962e45d22ccb62b2284b4fe4bbc9fdb50b252a59a" +
            "eefbebe2b895393fa0e9b5b31b19e65a63fee5d7b6261d8d5b6b847c5b637f03");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyMiMC(msg, uSignature, pubKey));

    });

    it("Sign (using Poseidon) a single 10 bytes from 0 to 9", () => {
        const msgBuf = Buffer.from("00010203040506070809", "hex");
        const msg = utils.leBuff2int(msgBuf);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        assert.equal(pubKey[0].toString(),
            "17579234973106307986399040784563986669343100608865726413246909559198451825625");
        assert.equal(pubKey[1].toString(),
            "21581828029826859845363968476425861244058376747493285816141526544272562145486");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signPoseidon(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "12672422877531089818651367820728973438446851190471722610781936061829103362897");
        assert.equal(signature.R8[1].toString(),
            "12052234579439634484237590306927118446073354173341433290934144373261241958718");
        assert.equal(signature.S.toString(),
            "2318334603430781860679872910160434499077270843466490702990199622594868564504");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "3e417cd811f9c9c545a680b962e45d22ccb62b2284b4fe4bbc9fdb50b252a59a" +
            "1852c049fc6286138a0ddb57718049a09374fdf0390686c7ac5637b481212005");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyPoseidon(msg, uSignature, pubKey));

    });
});
