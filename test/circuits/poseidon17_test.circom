pragma circom 2.0.0;
include "../../circuits/poseidon.circom";

// The round constants exist for 1 to 16 inputs. 17 must be rejected at compile time.
component main = Poseidon(17);
