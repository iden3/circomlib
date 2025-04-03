pragma circom 2.0.0;

include "./poseidon2_constants.circom";

template SBox() {
  signal input  inp;
  signal output out;

  signal x2 <== inp*inp;
  signal x4 <== x2*x2;

  out <== inp*x4;
}

// partial or internal round
template InternalRound(i) {
  signal input  inp[3];
  signal output out[3];

  var round_consts_int[56] = POSEIDON_C_INT(3);

  component sb = SBox();
  sb.inp <== inp[0] + round_consts_int[i];

  out[0] <== 2*sb.out +   inp[1] +   inp[2];
  out[1] <==   sb.out + 2*inp[1] +   inp[2];
  out[2] <==   sb.out +   inp[1] + 3*inp[2];

}

template ExternalRound(i) {
  signal input  inp[3];
  signal output out[3];

  var round_consts_ext[8][3] = POSEIDON_C_EXT(3);

  component sb[3];
  for(var j=0; j<3; j++) {
    sb[j] = SBox();
    sb[j].inp <== inp[j] + round_consts_ext[i][j];
  }

  out[0] <== 2*sb[0].out +   sb[1].out +   sb[2].out;
  out[1] <==   sb[0].out + 2*sb[1].out +   sb[2].out;
  out[2] <==   sb[0].out +   sb[1].out + 2*sb[2].out;
}

template LinearLayer() {
  signal input  inp[3];
  signal output out[3];
  out[0] <== 2*inp[0] +   inp[1] +   inp[2];
  out[1] <==   inp[0] + 2*inp[1] +   inp[2];
  out[2] <==   inp[0] +   inp[1] + 2*inp[2]; 
}

template Permutation() {
  signal input  inp[3];
  signal output out[3];

  signal aux[65][3];

  component ll = LinearLayer();
  for(var j=0; j<3; j++) { ll.inp[j] <== inp[j];    }
  for(var j=0; j<3; j++) { ll.out[j] ==> aux[0][j]; }

  component ext[8];
  for(var k=0; k<8; k++) { ext[k] = ExternalRound(k); }
 
  component int[56];
  for(var k=0; k<56; k++) { int[k] = InternalRound(k); }

  // first 4 external rounds
  for(var k=0; k<4; k++) {
    for(var j=0; j<3; j++) { ext[k].inp[j] <== aux[k  ][j]; }
    for(var j=0; j<3; j++) { ext[k].out[j] ==> aux[k+1][j]; }
  }

  // the 56 internal rounds
  for(var k=0; k<56; k++) {
    for(var j=0; j<3; j++) { int[k].inp[j] <== aux[k+4][j]; }
    for(var j=0; j<3; j++) { int[k].out[j] ==> aux[k+5][j]; }
  }

  // last 4 external rounds
  for(var k=0; k<4; k++) {
    for(var j=0; j<3; j++) { ext[k+4].inp[j] <== aux[k+60][j]; }
    for(var j=0; j<3; j++) { ext[k+4].out[j] ==> aux[k+61][j]; }
  }

  for(var j=0; j<3; j++) { out[j] <== aux[64][j]; }
}

template Compression() {
  signal input  inputs[2];
  signal output out;

  component perm = Permutation();
  perm.inp[0] <== inputs[0];
  perm.inp[1] <== inputs[1];
  perm.inp[2] <== 0;

  perm.out[0] ==> out;
}

// component main {public [inp]} = Compression();
