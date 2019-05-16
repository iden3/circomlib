const chai = require("chai");
const snarkjs = require("snarkjs");

const eddsa = require("../src/eddsa.js");
const babyJub = require("../src/babyjub.js");

const assert = chai.assert;

const bigInt = snarkjs.bigInt;

describe("EdDSA js test", function () {

    this.timeout(100000);

    it("Sign a single 10 bytes from 0 to 9", () => {
        const msgBuf = Buffer.from("00010203040506070809", "hex");
        const msg = bigInt.leBuff2int(msgBuf);

        //  const prvKey = crypto.randomBytes(32);

        const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

        const pubKey = eddsa.prv2pub(prvKey);

        assert.equal(pubKey[0].toString(),
            "2610057752638682202795145288373380503107623443963127956230801721756904484787");
        assert.equal(pubKey[1].toString(),
            "16617171478497210597712478520507818259149717466230047843969353176573634386897");

        const pPubKey = babyJub.packPoint(pubKey);

        const signature = eddsa.signMiMC(prvKey, msg);
        assert.equal(signature.R8[0].toString(),
            "4974729414807584049518234760796200867685098748448054182902488636762478901554");
        assert.equal(signature.R8[1].toString(),
            "18714049394522540751536514815950425694461287643205706667341348804546050128733");
        assert.equal(signature.S.toString(),
            "2171284143457722024136077617757713039502332290425057126942676527240038689549");

        const pSignature = eddsa.packSignature(signature);
        assert.equal(pSignature.toString("hex"), ""+
            "5dfb6f843c023fe3e52548ccf22e55c81b426f7af81b4f51f7152f2fcfc65f29"+
            "0dab19c5a0a75973cd75a54780de0c3a41ede6f57396fe99b5307fff3ce7cc04");

        const uSignature = eddsa.unpackSignature(pSignature);
        assert(eddsa.verifyMiMC(msg, uSignature, pubKey));

    });
});
