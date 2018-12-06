const mimc = require("./mimc7");

const SEED = "iden3_mimc";

let nRounds;
if (typeof process.argv[2] != "undefined") {
    nRounds = parseInt(process.argv[2]);
} else {
    nRounds = 256;
}

const cts = mimc.getConstants(SEED, nRounds);

for (let i=0; i<nRounds; i++) {
    let S = cts[i];
    if (i<nRounds-1) S=S+",";
    console.log(S);
}
