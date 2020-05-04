/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/

include "_mimc_feistel.circom"

// implements MiMC-2n/n as hash using a sponge construction.
// log_5(21888242871839275222246405745257275088548364400416034343698204186575808495617) ~= 110
// => nRounds should be 220

template MiMCSponge(nInputs, nRounds, nOutputs) {
  signal input ins[nInputs];
  signal input k;
  signal output outs[nOutputs];

  var i;

  // S = R||C
  component S[nInputs + nOutputs - 1];

  for (i = 0; i < nInputs; i++) {
    S[i] = MiMCFeistel(nRounds);
    S[i].k <== k;
    if (i == 0) {
      S[i].xL_in <== ins[0];
      S[i].xR_in <== 0;
    } else {
      S[i].xL_in <== S[i-1].xL_out + ins[i];
      S[i].xR_in <== S[i-1].xR_out;
    }
  }

  outs[0] <== S[nInputs - 1].xL_out;

  for (i = 0; i < nOutputs - 1; i++) {
    S[nInputs + i] = MiMCFeistel(nRounds);
    S[nInputs + i].k <== k;
    S[nInputs + i].xL_in <== S[nInputs + i - 1].xL_out;
    S[nInputs + i].xR_in <== S[nInputs + i - 1].xR_out;
    outs[i + 1] <== S[nInputs + i].xL_out;
  }
}