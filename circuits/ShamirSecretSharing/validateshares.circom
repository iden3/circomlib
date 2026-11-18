/* Shamir Secret Sharing
    The purpose of shamir secret sharing is to share a secret message with n parties, and none of them know each others share value. On combining the shares using lagrange bases, we get the message back. Here we make lagrange basis polynomials and evaluate it at 0 (becoz constant term is our goal).

    Example: 
        1. Suppose we have message = 14.
        2. And we sample random values from the Field Fp and make a polynomial (deg = n-1, where n = #shares) with message=14 as the constant term.
         Example equation P(x)= 7x^3 + 6x^2 + 4x + 14.
        3. This program verifies that the evaluations of P(x) at points in x[], is correct. Suppose "x": [1,2,3,4], "shares":[31,102,269,574].
        4. Then on combining the shares using the lagrange bases on x, we must get the message back. 
*/
pragma circom 2.1.8;
include "../comparators.circom";

// Objective: Find the univariate lagrange basis polynomial evaluations at 0 using the distintct set of points in[] 
template LagrangeBasis(n){
    signal input in[n];                 //evaluation points
    signal output out[n];               // outs lagrange bases eval at point 0
    signal stmp[n];
    signal one<--1;
    for (var i=0;i<n;i++){
        var tmp = 1;
        var j=0;
        while(j<n){
            if(i==j) {j++;}
            else{
                tmp *= (0-in[j])/(in[i]-in[j]); // a/b means a*INV(b) in circom
                j++;
            }
	}
	stmp[i] <-- tmp;
        out[i] <== one*stmp[i];
    }
}


//Objective: Check whether the given shares are valid and is equal to the shared message m. 
template ValidateShares(n){		// n is the number of shares
    signal input x[n];              // shares are eval at these points
    signal input shares[n];         // shares values
    signal input message;           // shared message
    signal output out;              // Outs 1 if valid, 0 otherwise
    var sum=0;
    
    component bases = LagrangeBasis(n);
    for( var i=0;i<n;i++) bases.in[i] <-- x[i];

    for(var i=0;i<n;i++){
        sum += bases.out[i] * shares[i];
    }
    signal ssum <-- sum;
    component isE = IsEqual();
    isE.in[0] <-- ssum; 
    isE.in[1] <-- message;
    out <== isE.out;
}
