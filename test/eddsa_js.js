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
            "13277427435165878497778222415993513565335242147425444199013288855685581939618");
        assert.equal(pubKey[1].toString(),
            "13622229784656158136036771217484571176836296686641868549125388198837476602820");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signMiMC(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "11384336176656855268977457483345535180380036354188103142384839473266348197733");
        assert.equal(signature.R8[1].toString(),
            "15383486972088797283337779941324724402501462225528836549661220478783371668959");
        assert.equal(signature.S.toString(),
            "2523202440825208709475937830811065542425109372212752003460238913256192595070");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "dfedb4315d3f2eb4de2d3c510d7a987dcab67089c8ace06308827bf5bcbe02a2"+
            "7ed40dab29bf993c928e789d007387998901a24913d44fddb64b1f21fc149405");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyMiMC(msg, uSignature, pubKey));

    });

    it("Sign (using Poseidon) a single 10 bytes from 0 to 9", () => {
        const msgBuf = Buffer.from("00010203040506070809", "hex");
        const msg = utils.leBuff2int(msgBuf);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        assert.equal(pubKey[0].toString(),
            "13277427435165878497778222415993513565335242147425444199013288855685581939618");
        assert.equal(pubKey[1].toString(),
            "13622229784656158136036771217484571176836296686641868549125388198837476602820");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signPoseidon(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "11384336176656855268977457483345535180380036354188103142384839473266348197733");
        assert.equal(signature.R8[1].toString(),
            "15383486972088797283337779941324724402501462225528836549661220478783371668959");
        assert.equal(signature.S.toString(),
            "938949321795232811108166733391487122595698117244126885899082887611217406272");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "dfedb4315d3f2eb4de2d3c510d7a987dcab67089c8ace06308827bf5bcbe02a2"+
            "40e930f04ce3a13bdca883639e77d1a0cd52b5ed0666df8a201df1fe2d6d1302");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyPoseidon(msg, uSignature, pubKey));

    });
});
