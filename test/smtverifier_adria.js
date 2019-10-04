const path = require("path");
const snarkjs = require("snarkjs");
const compiler = require("circom");
const fs = require("fs")

const bigInt = snarkjs.bigInt;
const smt = require("../src/smt.js");

const circuitSource = `
include "../circuits/smt/smtverifier.circom";
template SMT(nLevels) {
  signal input root;
  signal input mtp[nLevels];
  signal input hi;
  signal input hv;

  component smtClaimExists = SMTVerifier(nLevels);
  smtClaimExists.enabled <== 1;
  smtClaimExists.fnc <== 0;
  smtClaimExists.root <== root;
  for (var i=0; i<nLevels; i++) {
      smtClaimExists.siblings[i] <==  mtp[i];
  }
  smtClaimExists.oldKey <== 0;
  smtClaimExists.oldValue <== 0;
  smtClaimExists.isOld0 <== 0;

  smtClaimExists.key <== hi;
  smtClaimExists.value <== hv;
}
component main = SMT(4);
`;

describe("smt3test", function () {
    this.timeout(200000);

    let circuitFileName;

    before( async () => {
        circuitFileName = path.join(__dirname, ".", "rawsmt3.circom");
        fs.writeFileSync(circuitFileName,circuitSource);
    });

    const levels = 4;
    async function testsmt3(e1, e2) {
        let tree = await smt.newMemEmptyTrie();

        // insert e1, e2
        await tree.insert(e1.hi, e1.hv);
        await tree.insert(e2.hi, e2.hv);

        // generate proof for e1
        const findInfo = await tree.find(e1.hi);
        const siblings = findInfo.siblings;
        while (siblings.length < levels) siblings.push(bigInt(0));

        const input = {
            root: tree.root,
            mtp: siblings,
            hi: e1.hi,
            hv: e1.hv,
        };

        const compiledCircuit = await compiler(
            circuitFileName,
            { reduceConstraints: false }
        );

        const circuit = new snarkjs.Circuit(compiledCircuit);
        const witness = circuit.calculateWitness(input);
        circuit.checkWitness(witness);
    }

    it("TestSmts", async () => {

        const e1 = {
            hi: bigInt("17124152697573569611556136390143205198134245887034837071647643529178599000839"),
            hv: bigInt("19650379996168153643111744440707177573540245771926102415571667548153444658179"),
        };

        const e2ok = {
            hi: bigInt("16498254692537945203721083102154618658340563351558973077349594629411025251262"),
            hv: bigInt("19650379996168153643111744440707177573540245771926102415571667548153444658179"),
        };

        const e2fail = {
            hi: bigInt("17195092312975762537892237130737365903429674363577646686847513978084990105579"),
            hv: bigInt("19650379996168153643111744440707177573540245771926102415571667548153444658179"),
        };

        console.log("test e1, e2ok");
        await testsmt3(e1, e2ok);

        console.log("test e1, e2fail");
        await testsmt3(e1, e2fail);
    });
});

