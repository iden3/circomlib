include "tonelishanks.circom";
include "compconstant.circom";

include "bitify.circom";

template WeierstrassExpr(A,B) {
  signal input in;
  signal output out;
  signal in2;
  in2 <== in*in;
  out <== in2*in + A*in + B;
}

template Weierstrass2Edwards(S, T) {
  signal input in[2];
  signal output out[2];

  out[0] <-- (in[0] - T)/in[1];
  out[1] <-- (in[0] - T - S)/(in[0]-T+S);

  out[0]*in[1] - in[0] + T === 0;
  out[1]*in[0] + out[1]*(-T+S) - in[0] + T + S === 0; 
}

template SWUSelect() {
  var WA=7296080957279758407415468581752425029516121466805344781232734728849116493472;
  var WB=16213513238399463127589930181672055621146936592900766180517188641980520820846;
  var S=1;
  var T=7296080957279758407415468581752425029516121466805344781232734728858602888105;
  var g=1621351323839946312758993018167205562114693659290076618051719184253828818702;


  signal input in;
  signal output out[2];

  component t0 = IsZero();
  t0.in <== in;

  signal t;
  t <== in + (1-t0.out)*70297686841582442057940100194421294204074774541372193073554880658839844120511;

  signal t2g;
  t2g <== g * t * t;

  signal t4g2t2g;
  t4g2t2g <== t2g * t2g + t2g;

  component w2 = WeierstrassExpr(WA, WB);
  w2.in <-- - WB/WA * (1 + 1/t4g2t2g);
  w2.in * t4g2t2g + WB/WA * (t4g2t2g + 1) === 0

  component w3 = WeierstrassExpr(WA, WB);
  w3.in <== t2g * w2.in;

  component issqr = isSquare();
  issqr.in <== w2.out;

  component squareroot = ToneliShanks();
  squareroot.in <== w3.out + (w2.out-w3.out)*issqr.out;

  component w2e = Weierstrass2Edwards(S, T);
  w2e.in[0] <== w3.in + (w2.in-w3.in)*issqr.out;
  w2e.in[1] <== squareroot.out;


  component xbits = Num2Bits_strict()
  xbits.in <== w2e.out[0]
  
  component signCalc = CompConstant(10944121435919637611123202872628637544274182200208017171849102093287904247808);
  for (var i=0; i<254; i++) {
      signCalc.in[i] <== xbits.out[i];
  }

  component dbl1 = BabyDbl();
  dbl1.x <== xbits.in * (2 * signCalc.out - 1);
  dbl1.y <== w2e.out[1];
  component dbl2 = BabyDbl();
  dbl2.x <== dbl1.xout;
  dbl2.y <== dbl1.yout;
  component dbl3 = BabyDbl();
  dbl3.x <== dbl2.xout;
  dbl3.y <== dbl2.yout;

  out[0] <== dbl3.x;
  out[1] <== dbl3.y;

}