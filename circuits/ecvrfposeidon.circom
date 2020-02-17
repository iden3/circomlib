include "bitify.circom";
include "escalarmulany.circom";
include "escalarmulfix.circom";
include "comparators.circom";
include "babyjub.circom";
include "swupointpicker.circom";
include "esubgroupcheck.circom";
include "poseidon.circom";

// assume Q in subgroup
// assume Gamma in subgroup

template IsECVRFPoseidon(S, C) {
  signal input Q[2];
  signal input Gamma[2];
  signal input s[S];
  signal input c[C];
  signal input alpha;
  signal output out;

  var G8 = [
    5299619240641551281634865583518297030282874472190772894086521144482721001553,
    16950150798460657717958625567821834550301663161624707787222815936182638968203
  ];

  component hash = Poseidon(2, 6, 8, 57);
  hash.inputs[0] <== Q[0];
  hash.inputs[1] <== alpha;

  component H = SWUSelect();
  H.in <== hash.out;


  component sG8 = EscalarMulFix(S, G8);
  
  component cQ = EscalarMulAny(C);
  cQ.p[0] <== -Q[0];
  cQ.p[1] <== Q[1];

  component sH = EscalarMulAny(S);
  sH.p[0] <== H.out[0];
  sH.p[1] <== H.out[1];
 
  component cGamma = EscalarMulAny(C);
  cGamma.p[0] <== -Gamma[0];
  cGamma.p[1] <== Gamma[1];

  
  for(var i=0; i<S; i++) {
    sG8.e[i] <== s[i];
    sH.e[i] <== s[i];
  }

  component c_num = Bits2Num(C);

  for(var i=0; i<C; i++) {
    cQ.e[i] <== c[i];
    cGamma.e[i] <== c[i];
    c_num.in[i] <== c[i];
  }


  component u = BabyAdd();
  u.x1 <== sG8.out[0];
  u.y1 <== sG8.out[1];
  u.x2 <== cQ.out[0];
  u.y2 <== cQ.out[1];

  component v = BabyAdd();
  v.x1 <== sH.out[0];
  v.y1 <== sH.out[1];
  v.x2 <== cGamma.out[0];
  v.y2 <== cGamma.out[1];

  component HGammaUV = Poseidon(4, 6, 8, 57);
  HGammaUV.inputs[0] <== H.out[0];
  HGammaUV.inputs[1] <== Gamma[0];
  HGammaUV.inputs[2] <== u.xout;
  HGammaUV.inputs[3] <== v.xout;

  component result = IsZero();

  result.in <== c_num.out - HGammaUV.out;

  out <== result.out;
  
}

