/*
*** nbits(x): function that returns the number of bits that we need to represent the value x
        - Inputs: x -> field value 
        - Output: number of bits needed to represent x
        
    Example: nbits(7) = 3, nbits(10) = 4

*/

function nbits(a) {
    var n = 1;
    var r = 0;
    while (n-1<a) {
        r++;
        n *= 2;
    }
    return r;
}
