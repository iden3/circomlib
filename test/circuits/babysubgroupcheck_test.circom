pragma circom 2.1.5;

include "../../circuits/babyjub.circom";

// BabySubgroupCheck: accepts a point of the curve exactly when it is in the prime order
// subgroup, and returns it unchanged carrying the babysubgroup tag.

template Main(){
    input Point p;
    output Point {babyedwards, babysubgroup} out <== BabySubgroupCheck()(BabyCheck()(p));
}

component main = Main();
