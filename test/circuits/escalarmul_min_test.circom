include "../../circuits/escalarmul.circom";


template Main() {
    signal input in[256];
    signal output out[2];

    var i;

    var base = [17777552123799933955779906779655732241715742912184938656739573121738514868268,
                2626589144620713026669568689430873010625803728049924121243784502389097019475]

    component escalarMul = EscalarMul(256, base);

    escalarMul.inp[0] <== 0;
    escalarMul.inp[1] <== 1;

    for  (i=0; i<256; i++) {
        in[i] ==> escalarMul.in[i];
    }

    escalarMul.out[0] ==> out[0];
    escalarMul.out[1] ==> out[1];
}

component main = Main();
