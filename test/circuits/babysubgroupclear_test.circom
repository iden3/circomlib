pragma circom 2.1.5;

include "../../circuits/babyjub.circom";

// BabySubgroupClear: returns 8 times the input, which is in the prime order subgroup for
// any point of the curve, carrying the babysubgroup tag.

template Main(){
    input Point p;
    output Point {babyedwards, babysubgroup} out <== BabySubgroupClear()(BabyCheck()(p));
}

component main = Main();
