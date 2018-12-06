include "../../circuits/escalarmulfix.circom";
include "../../circuits/bitify.circom";


template Main() {
    signal input e;
    signal output out[2];

    var base = [17777552123799933955779906779655732241715742912184938656739573121738514868268,
            2626589144620713026669568689430873010625803728049924121243784502389097019475]


    component n2b = Num2Bits(253);
    component escalarMul = EscalarMulFix(253, base);

    var i;

    e ==> n2b.in;

    for  (i=0; i<253; i++) {
        n2b.out[i] ==> escalarMul.e[i];
    }

    escalarMul.out[0] ==> out[0];
    escalarMul.out[1] ==> out[1];
}

component main = Main();

