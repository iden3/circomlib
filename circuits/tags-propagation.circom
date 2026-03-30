pragma circom 2.1.5;

// The templates and functions in this file are general and work for any prime field



/*
*** BinaryToMaxbit(): template receives an input signal with the tag binary and returns a signal with the tag maxbit = 1
        - Inputs: in -> field value
                        requires tag binary
        - Output: out -> same value as in, but including tag maxbit = 1
                         satisfies tags binary, maxbit = 1
         
    Note: The template does not add any extra check
*/

template BinaryToMaxbit(){
    signal input {binary} in;
    signal output {maxbit, binary} out;
    
    out.maxbit = 1;
    out <== in;
}

/*
*** BinaryToMaxvalue(): template receives an input signal with the tag binary and returns a signal with the tag maxvalue = 1
        - Inputs: in -> field value
                        requires tag binary
        - Output: out -> same value as in, but including tag maxvalue = 1
                         satisfies tags binary, maxvalue = 1
         
    Note: The template does not add any extra check
*/

template BinaryToMaxvalue(){
    signal input {binary} in;
    signal output {maxvalue, binary} out;
    
    out.maxvalue = 1;
    out <== in;
}

/*
*** MaxbitToBinary(n): template receives an input signal with the tag maxbit <= 1 and returns a signal with the tag binary
        - Inputs: in -> field value
                        requires tag maxbit
        - Output: out -> same value as in, but including tag binary
                         satisfies tags maxbit, binary
         
    Note: The template does not add any extra check
          In case in.maxbit > 1 then the template returns a compilation error
*/

template MaxbitToBinary(){
    signal input {maxbit} in;
    signal output {binary, maxbit} out;
    
    assert(in.maxbit <= 1);
    out <== in;
}

/*
*** MaxbitToMaxvalue(): template receives an input signal with the tag maxbit and returns a signal with the tag maxvalue s.t. maxvalue = 2 ** maxbit - 1
        - Inputs: in -> field value
                        requires tag maxbit
        - Output: out -> same value as in, but including tag maxvalue
                         satisfies tags maxbit, maxvalue s.t. out.maxvalue = 2 ** in.maxbit - 1
         
    Note: The template does not add any extra check
*/

template MaxbitToMaxvalue(){
    signal input {maxbit} in;
    signal output {maxvalue, maxbit} out;
    
    assert(out.maxbit <= 252);
    
    out.maxvalue = 2 ** in.maxbit - 1;
    out <== in;
}

/*
*** MaxvalueToBinary(): template receives an input signal with the tag maxvalue <= 1 and returns a signal with the tag binary
        - Inputs: in -> field value
                        requires tag maxvalue
        - Output: out -> same value as in, but including tag binary
                         satisfies tags maxvalue, binary
         
    Note: The template does not add any extra check
          In case in.maxvalue > 1 then the template returns a compilation error
*/

template MaxvalueToBinary(){
    signal input {maxvalue} in;
    signal output {binary, maxvalue} out;
    
    assert(in.maxvalue <= 1);
    out <== in;
}

/*
*** MaxvalueToMaxbit(): template receives an input signal with the tag maxvalue and returns a signal with the tag maxbit s.t. maxbit = nbits(maxvalue)
        - Inputs: in -> field value
                        requires tag maxvalue
        - Output: out -> same value as in, but including tag maxbit
                         satisfies tags maxvalue, maxbit s.t. out.maxbit = nbits(in.maxvalue)
         
    Note: The template does not add any extra check
*/

template MaxvalueToMaxbit(){
    signal input {maxvalue} in;
    signal output {maxbit, maxvalue} out;
    
    out.maxbit = nbits(in.maxvalue);
    out <== in;
}


/*
*** RelaxMaxbit(n): template receives an input signal with the tag maxbit and the new maxbit value n to be assigned and in case the new condition is ensured (in.maxbit <= n) then it returns an output signal in == out s.t. out.maxbit = n
        - Inputs: in -> field value
                        requires tag maxbit
        - Output: out -> same value as in, but including tag maxbit = n
                         satisfies tags maxbit = n
         
    Note: The template does not add any extra check
          In case in.maxbit > n then the template returns a compilation error
*/

template RelaxMaxbit(n){
    signal input {maxbit} in;
    signal output {maxbit} out;
    
    assert(out.maxbit <= n);
    
    out.maxbit = n;
    out <== in;
}


/*
*** RelaxMaxvalue(n): template receives an input signal with the tag maxvalue and the new maxvalue value n to be assigned and in case the new condition is ensured (in.maxvalue <= n) then it returns an output signal in == out s.t. out.maxvalue = n
        - Inputs: in -> field value
                        requires tag maxvalue
        - Output: out -> same value as in, but including tag maxvalue = n
                         satisfies tags maxvalue = n
         
    Note: The template does not add any extra check
          In case in.maxvalue > n then the template returns a compilation error
*/

template RelaxMaxvalue(n){
    signal input {maxvalue} in;
    signal output {maxvalue} out;
    
    assert(out.maxvalue <= n);
    
    out.maxvalue = n;
    out <== in;
}


/*
*** ConstantToBinary(ct): template receives constant (0 or 1) and returns a signal containing this value and satisfying the tag binary
        - Output: out -> out = ct (constant parameter of the template)
                         satisfies tags binary
         
    Note: The template does not add any extra check
          In case ct is not 0 or 1 then the template returns a compilation error
*/

template ConstantToBinary(ct){
    signal output {binary} out;
    
    assert(0 <= ct && ct <= 1);
    out <== ct;
}


/*
*** ConstantToMaxbit(ct, n): template receives constant (that should satisfy 0 <= ct < 2**n) and returns a signal containing this value and satisfying the tag maxbit = n
        - Output: out -> out = ct (constant parameter of the template)
                         satisfies tags maxbit = n
         
    Note: The template does not add any extra check
          In case ct does not satisfy 0 <= ct < 2 ** n then the template returns a compilation error
*/

template ConstantToMaxbit(ct, n){
    signal output {maxbit} out;
    
    assert(0 <= ct && ct < 2**n);
    out.maxbit = n;
    out <== ct;
}


/*
*** ConstantToMaxvalue(ct, n): template receives constant (that should satisfy 0 <= ct <= n) and returns a signal containing this value and satisfying the tag maxvalue = n
        - Output: out -> out = ct (constant parameter of the template)
                         satisfies tags maxvalue = n
         
    Note: The template does not add any extra check
          In case ct does not satisfy 0 <= ct <= value then the template returns a compilation error
*/

template ConstantToMaxvalue(ct, n){
    signal output {max} out;
    
    assert(0 <= ct && ct <= n);
    out.maxvalue = n;
    out <== ct;
}
