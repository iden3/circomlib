const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;
const Web3 = require("web3");
const F = bn128.Fr;

module.exports.hash = MiMC7Hash;
module.exports.getConstants = getConstants;

const SEED = "iden3_mimc";

function getConstants(seed, nRounds) {
    const cts = new Array(nRounds);
    let c = Web3.utils.keccak256(SEED);
    for (let i=1; i<nRounds; i++) {
        c = Web3.utils.keccak256(c);

        const n1 = Web3.utils.toBN(c).mod(Web3.utils.toBN(F.q.toString()));
        cts[i] = Web3.utils.padLeft(Web3.utils.toHex(n1), 64);
    }
    cts[0] = "0x0000000000000000000000000000000000000000000000000000000000000000";
    return cts;
}

function MiMC7Hash(_x_in, _k, nRounds) {
    const x_in = bigInt(_x_in);
    const k = bigInt(_k);
    const cts = getConstants(SEED, nRounds);
    let r;
    for (let i=0; i<nRounds; i++) {
        const c = bigInt(Web3.utils.toBN(cts[i]).toString());
        let t = (i==0) ? F.add(x_in, k) : F.add(F.add(r, k), c);
        let t2 = F.square(t);
        let t4 = F.square(t2);
        r = F.mul(F.mul(t4, t2), t);
    }
    return F.affine(F.add(r, k));
}
