pragma circom 2.0.0;

template SBox() {
  signal input  inp;
  signal output out;

  signal x2 <== inp*inp;
  signal x4 <== x2*x2;

  out <== inp*x4;
}

// partial or internal round
template InternalRound(i) {
  signal input  inp[3];
  signal output out[3];

  var round_consts[56] = 
    [ 0x15ce7e5ae220e8623a40b3a3b22d441eff0c9be1ae1d32f1b777af84eea7e38c
    , 0x1bf60ac8bfff0f631983c93e218ca0d4a4059c254b4299b1d9984a07edccfaf0
    , 0x0fab0c9387cb2bec9dc11b2951088b9e1e1d2978542fc131f74a8f8fdac95b40
    , 0x07d085a48750738019784663bccd460656dc62c1b18964a0d27a5bd0c27ee453
    , 0x10d57b1fad99da9d3fe16cf7f5dae05be844f67b2e7db3472a2e96e167578bc4
    , 0x0c36c40f7bd1934b7d5525031467aa39aeaea461996a70eda5a2a704e1733bb0
    , 0x0e4b65a0f3e1f9d3166a2145063c999bd08a4679676d765f4d11f97ed5c080ae
    , 0x1ce5561061120d5c7ea09da2528c4c041b9ad0f05d655f38b10d79878b69f29d
    , 0x2d323f651c3da8f0e0754391a10fa111b25dfa00471edf5493c44dfc3f28add6
    , 0x05a0741ee5bdc3e099fd6bdad9a0865bc9ceecd13ea4e702e536dd370b8f1953
    , 0x176a2ec4746fc0e0eca9e5e11d6facaee05524a92e5785c8b8161780a4435136
    , 0x0691faf0f42a9ed97629b1ae0dc7f1b019c06dd852cb6efe57f7eeb1aa865aef
    , 0x0e46cf138dad09d61b9a7cab95a23b5c8cb276874f3715598bacb55d5ad271de
    , 0x0f18c3d95bac1ac424160d240cdffc2c44f7b6315ba65ed3ff2eff5b3e48b4f2
    , 0x2eea6af14b592ec45a4119ac1e6e6f0312ecd090a096e340d472283e543ddff7
    , 0x06b0d7a8f4ce97d049ae994139f5f71dca4899d4f1cd3dd83a32a89a58c0a8e6
    , 0x019df0b9828eed5892dd55c1ad6408196f6293d600ef4491703a1b37e119ba8e
    , 0x08ca5e3c93817cdb1c2b2a12d02c779d74c1bb12b6668f3ab3ddd7837f3a4a00
    , 0x28382d747e3fd6cb2e0d8e8edd79c5313eed307a3517c11046245b1476e4f701
    , 0x0ca89aecd5675b77c8271765da98cfcb6875b3053d4742c9ff502861bd16ad28
    , 0x19046bc0b03ca90802ec83f212001e7ffd7f9224cfffae523451deb52eab3787
    , 0x036fd7dfa1c05110b3428e6abcc43e1de9abba915320c4a600f843bfb676ca51
    , 0x08f0a7abcb1a2f6595a9b7380c5028e3999db4fe5cb21892e5bb5cb11a7757ba
    , 0x0b614acc1ce3fbe9048f8385e4ee24c3843deea186bacea3c904c9f6340ad8cb
    , 0x00b2d98c5d988f9b41f2c98e017fc954a6ae423b2261575941f8eac8835d985c
    , 0x1457f18555b7973ba5b311d57ec5d77e936980b97f5973875f1f7cc765a4fc95
    , 0x002b453debc1bee525cb751bc10641a6b86f847d696418cf1144950982591bfa
    , 0x0c2af1abcc6ece77218315d2af445ccbfc6647b7af2510682882cc792c6bb8cf
    , 0x0e2825d9eb84b59902a1adb49ac0c2c291dee7c45d2e8c30369a4d595039e8ad
    , 0x297e2e86a8c672d39f3343b8dfce7a6f20f3571bfd5c8a28e3905aa2dcfeca44
    , 0x00d397281d902e49ec6504ba9186e806db9ad4fc8f86e7277aa7f1467eb6f9de
    , 0x2fb7c89c372d7e2050e7377ed471000c73544a2b9fd66557f3577c09cac98b4b
    , 0x16125247be4387a8c3e62490167f0cffdba02eda4f018d0b40639a13bb0cfef9
    , 0x2291fd9d442f2d9b97ab22f7d4d52c2a82e41f852cf620b144612650a39e26e8
    , 0x1eec61f16a275ae238540feaeeadfec56d32171b1cc393729d06f37f476fde71
    , 0x259ce871ba5dacbb48d8aed3d8513eef51558dc0b360f28c1a15dbfc5e7f6ca2
    , 0x2d3376a14ddbf95587e2f7567ff04fe13a3c7cb17363c8b9c5dd1d9262a210cb
    , 0x13b843d9f65f4cddd7ce10d9cad9b8b99ac5e9a8c4269288173a91c0f3c3b084
    , 0x0b52e9b2f1aa9fd204e4a42c481cc76c704783e34114b8e93e026a50fa9764e8
    , 0x1fd083229276c7f27d3ad941476b394ff37bd44d3a1e9caca1400d9077a2056c
    , 0x22743c328a6283f3ba7379af22c684c498568fd7ad9fad5151368c913197cbd9
    , 0x043007aefd9741070d95caaaba0c1b070e4eec8eef8c1e512c8e579c6ed64f76
    , 0x17ab175144f64bc843074f6b3a0c57c5dd2c954af8723c029ee642539496a7b3
    , 0x2befcad3d53fba5eeef8cae9668fed5c1e9e596a46e8458e218f7a665fddf4eb
    , 0x15151c4116d97de74bfa6ca3178f73c8fe8fe612c70c6f85a7a1551942cb71cc
    , 0x2ac40bf6c3176300a6835d5fc7cc4fd5e5d299fb1baa86487268ec1b9eedfa97
    , 0x0f151de1f01b4e24ffe04279318f0a68efabb485188f191e37e6915ff6059f6e
    , 0x2e43dffc34537535182aebac1ad7bf0a5533b88f65f9652f0ad584e2ffc4dd1f
    , 0x2ebabc2c37ef53d8b13b24a2a2b729d536735f58956125a3876da0664c2442d7
    , 0x0dc3beceb34e49f5ad7226dd202c5cf879dffcc9a6dd32a300e8f2a4b59edf03
    , 0x2f1ddeccce83adf68779c53b639871a8f81d4d00aefe1e812efce8ec999d457d
    , 0x1f63e41280ff5c021715d52b19780298ed8bd3d5eb506316b527e24149d4d4f1
    , 0x1b8c1252a5888f8cb2672effb5df49c633d3fd7183271488a1c40d0f88e7636e
    , 0x0f45697130f5498e2940568ef0d5e9e16b1095a6cdbb6411df20a973c605e70b
    , 0x0780ccc403cdd68983acbd34cda41cacfb2cf911a93076bc25587b4b0aed4929
    , 0x238d26ca97c691591e929f32199a643550f325f23a85d420080b289d7cecc9d4
    ];

  component sb = SBox();
  sb.inp <== inp[0] + round_consts[i];

  out[0] <== 2*sb.out +   inp[1] +   inp[2];
  out[1] <==   sb.out + 2*inp[1] +   inp[2];
  out[2] <==   sb.out +   inp[1] + 3*inp[2];

}

template ExternalRound(i) {
  signal input  inp[3];
  signal output out[3];

  var round_consts[8][3] = 

    [ [ 0x2c4c51fd1bb9567c27e99f5712b49e0574178b41b6f0a476cddc41d242cf2b43
      , 0x1c5f8d18acb9c61ec6fcbfcda5356f1b3fdee7dc22c99a5b73a2750e5b054104
      , 0x2d3c1988b4541e4c045595b8d574e98a7c2820314a82e67a4e380f1c4541ba90 
      ]
    , [ 0x052547dc9e6d936cab6680372f1734c39f490d0cb970e2077c82f7e4172943d3
      , 0x29d967f4002adcbb5a6037d644d36db91f591b088f69d9b4257694f5f9456bc2
      , 0x0350084b8305b91c426c25aeeecafc83fc5feec44b9636cb3b17d2121ec5b88a
      ]
    , [ 0x1815d1e52a8196127530cc1e79f07a0ccd815fb5d94d070631f89f6c724d4cbe
      , 0x17b5ba882530af5d70466e2b434b0ccb15b7a8c0138d64455281e7724a066272
      , 0x1c859b60226b443767b73cd1b08823620de310bc49ea48662626014cea449aee
      ]
    , [ 0x1b26e7f0ac7dd8b64c2f7a1904c958bb48d2635478a90d926f5ff2364effab37
      , 0x2da7f36850e6c377bdcdd380efd9e7c419555d3062b0997952dfbe5c54b1a22e
      , 0x17803c56450e74bc6c7ff97275390c017f682db11f3f4ca6e1f714efdfb9bd66
      ]
    , [ 0x25672a14b5d085e31a30a7e1d5675ebfab034fb04dc2ec5e544887523f98dede
      , 0x0cf702434b891e1b2f1d71883506d68cdb1be36fa125674a3019647b3a98accd
      , 0x1837e75235ff5d112a5eddf7a4939448748339e7b5f2de683cf0c0ae98bdfbb3
      ] 
    , [ 0x1cd8a14cff3a61f04197a083c6485581a7d836941f6832704837a24b2d15613a
      , 0x266f6d85be0cef2ece525ba6a54b647ff789785069882772e6cac8131eecc1e4
      , 0x0538fde2183c3f5833ecd9e07edf30fe977d28dd6f246d7960889d9928b506b3
      ] 
    , [ 0x07a0693ff41476abb4664f3442596aa8399fdccf245d65882fce9a37c268aa04
      , 0x11eb49b07d33de2bd60ea68e7f652beda15644ed7855ee5a45763b576d216e8e
      , 0x08f8887da6ce51a8c06041f64e22697895f34bacb8c0a39ec12bf597f7c67cfc
      ] 
    , [ 0x2a912ec610191eb7662f86a52cc64c0122bd5ba762e1db8da79b5949fdd38092
      , 0x2031d7fd91b80857aa1fef64e23cfad9a9ba8fe8c8d09de92b1edb592a44c290
      , 0x0f81ebce43c47711751fa64d6c007221016d485641c28c507d04fd3dc7fba1d2
      ] 
    ];

  component sb[3];
  for(var j=0; j<3; j++) {
    sb[j] = SBox();
    sb[j].inp <== inp[j] + round_consts[i][j];
  }

  out[0] <== 2*sb[0].out +   sb[1].out +   sb[2].out;
  out[1] <==   sb[0].out + 2*sb[1].out +   sb[2].out;
  out[2] <==   sb[0].out +   sb[1].out + 2*sb[2].out;
}

template LinearLayer() {
  signal input  inp[3];
  signal output out[3];
  out[0] <== 2*inp[0] +   inp[1] +   inp[2];
  out[1] <==   inp[0] + 2*inp[1] +   inp[2];
  out[2] <==   inp[0] +   inp[1] + 2*inp[2]; 
}

template Permutation() {
  signal input  inp[3];
  signal output out[3];

  signal aux[65][3];

  component ll = LinearLayer();
  for(var j=0; j<3; j++) { ll.inp[j] <== inp[j];    }
  for(var j=0; j<3; j++) { ll.out[j] ==> aux[0][j]; }

  component ext[8];
  for(var k=0; k<8; k++) { ext[k] = ExternalRound(k); }
 
  component int[56];
  for(var k=0; k<56; k++) { int[k] = InternalRound(k); }

  // first 4 external rounds
  for(var k=0; k<4; k++) {
    for(var j=0; j<3; j++) { ext[k].inp[j] <== aux[k  ][j]; }
    for(var j=0; j<3; j++) { ext[k].out[j] ==> aux[k+1][j]; }
  }

  // the 56 internal rounds
  for(var k=0; k<56; k++) {
    for(var j=0; j<3; j++) { int[k].inp[j] <== aux[k+4][j]; }
    for(var j=0; j<3; j++) { int[k].out[j] ==> aux[k+5][j]; }
  }

  // last 4 external rounds
  for(var k=0; k<4; k++) {
    for(var j=0; j<3; j++) { ext[k+4].inp[j] <== aux[k+60][j]; }
    for(var j=0; j<3; j++) { ext[k+4].out[j] ==> aux[k+61][j]; }
  }

  for(var j=0; j<3; j++) { out[j] <== aux[64][j]; }
}

template Compression() {
  signal input  inp[2];
  signal output out;

  component perm = Permutation();
  perm.inp[0] <== inp[0];
  perm.inp[1] <== inp[1];
  perm.inp[2] <== 0;

  perm.out[0] ==> out;
}

// component main {public [inp]} = Compression();
