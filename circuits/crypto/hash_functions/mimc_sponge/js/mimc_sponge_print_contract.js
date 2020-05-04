const mimcGenContract = require("./mimc_sponge_gen_contract");

const SEED = "mimcsponge";

let nRounds;
if (typeof process.argv[2] != "undefined") {
    nRounds = parseInt(process.argv[2]);
} else {
    nRounds = 220;
}

console.log(mimcGenContract.createCode(SEED, nRounds));

