const snarkjs = require("snarkjs");

let n = 16352677002768649294638363183714474939219394808856154771098596513875516795430n

let r = snarkjs.bn128.Fr.sqrt(n)

r = snarkjs.bn128.Fr.q -r;

console.log(r.toString());

