
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
