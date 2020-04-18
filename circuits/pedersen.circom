/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/

include "montgomery.circom";
include "mux3.circom";
include "babyjub.circom";

template Window4() {
    signal input in[4];
    signal input base[2];
    signal output out[2];
    signal output out8[2];   // Returns 8*Base (To be linked)

    component mux = MultiMux3(2);

    mux.s[0] <== in[0];
    mux.s[1] <== in[1];
    mux.s[2] <== in[2];

    component dbl2 = MontgomeryDouble();
    component adr3 = MontgomeryAdd();
    component adr4 = MontgomeryAdd();
    component adr5 = MontgomeryAdd();
    component adr6 = MontgomeryAdd();
    component adr7 = MontgomeryAdd();
    component adr8 = MontgomeryAdd();

// in[0]  -> 1*BASE

    mux.c[0][0] <== base[0];
    mux.c[1][0] <== base[1];

// in[1] -> 2*BASE
    dbl2.in[0] <== base[0];
    dbl2.in[1] <== base[1];
    mux.c[0][1] <== dbl2.out[0];
    mux.c[1][1] <== dbl2.out[1];

// in[2] -> 3*BASE
    adr3.in1[0] <== base[0];
    adr3.in1[1] <== base[1];
    adr3.in2[0] <== dbl2.out[0];
    adr3.in2[1] <== dbl2.out[1];
    mux.c[0][2] <== adr3.out[0];
    mux.c[1][2] <== adr3.out[1];

// in[3] -> 4*BASE
    adr4.in1[0] <== base[0];
    adr4.in1[1] <== base[1];
    adr4.in2[0] <== adr3.out[0];
    adr4.in2[1] <== adr3.out[1];
    mux.c[0][3] <== adr4.out[0];
    mux.c[1][3] <== adr4.out[1];

// in[4] -> 5*BASE
    adr5.in1[0] <== base[0];
    adr5.in1[1] <== base[1];
    adr5.in2[0] <== adr4.out[0];
    adr5.in2[1] <== adr4.out[1];
    mux.c[0][4] <== adr5.out[0];
    mux.c[1][4] <== adr5.out[1];

// in[5] -> 6*BASE
    adr6.in1[0] <== base[0];
    adr6.in1[1] <== base[1];
    adr6.in2[0] <== adr5.out[0];
    adr6.in2[1] <== adr5.out[1];
    mux.c[0][5] <== adr6.out[0];
    mux.c[1][5] <== adr6.out[1];

// in[6] -> 7*BASE
    adr7.in1[0] <== base[0];
    adr7.in1[1] <== base[1];
    adr7.in2[0] <== adr6.out[0];
    adr7.in2[1] <== adr6.out[1];
    mux.c[0][6] <== adr7.out[0];
    mux.c[1][6] <== adr7.out[1];

// in[7] -> 8*BASE
    adr8.in1[0] <== base[0];
    adr8.in1[1] <== base[1];
    adr8.in2[0] <== adr7.out[0];
    adr8.in2[1] <== adr7.out[1];
    mux.c[0][7] <== adr8.out[0];
    mux.c[1][7] <== adr8.out[1];

    out8[0] <== adr8.out[0];
    out8[1] <== adr8.out[1];

    out[0] <== mux.out[0];
    out[1] <== - mux.out[1]*2*in[3] + mux.out[1];  // Negate y if in[3] is one
}


template Segment(nWindows) {
    signal input in[nWindows*4];
    signal input base[2];
    signal output out[2];

    var i;
    var j;

    // Convert the base to montgomery

    component e2m = Edwards2Montgomery();
    e2m.in[0] <== base[0];
    e2m.in[1] <== base[1];

    component windows[nWindows];
    component doublers1[nWindows-1];
    component doublers2[nWindows-1];
    component adders[nWindows-1];
    for (i=0; i<nWindows; i++) {
        windows[i] = Window4();
        for (j=0; j<4; j++) {
            windows[i].in[j] <== in[4*i+j];
        }
        if (i==0) {
            windows[i].base[0] <== e2m.out[0];
            windows[i].base[1] <== e2m.out[1];
        } else {
            doublers1[i-1] = MontgomeryDouble();
            doublers2[i-1] = MontgomeryDouble();
            doublers1[i-1].in[0] <== windows[i-1].out8[0];
            doublers1[i-1].in[1] <== windows[i-1].out8[1];
            doublers2[i-1].in[0] <== doublers1[i-1].out[0];
            doublers2[i-1].in[1] <== doublers1[i-1].out[1];

            windows[i].base[0] <== doublers2[i-1].out[0];
            windows[i].base[1] <== doublers2[i-1].out[1];

            adders[i-1] = MontgomeryAdd();
            if (i==1) {
                adders[i-1].in1[0] <== windows[0].out[0];
                adders[i-1].in1[1] <== windows[0].out[1];
            } else {
                adders[i-1].in1[0] <== adders[i-2].out[0];
                adders[i-1].in1[1] <== adders[i-2].out[1];
            }
            adders[i-1].in2[0] <== windows[i].out[0];
            adders[i-1].in2[1] <== windows[i].out[1];
        }
    }

    component m2e = Montgomery2Edwards();

    if (nWindows > 1) {
        m2e.in[0] <== adders[nWindows-2].out[0];
        m2e.in[1] <== adders[nWindows-2].out[1];
    } else {
        m2e.in[0] <== windows[0].out[0];
        m2e.in[1] <== windows[0].out[1];
    }

    out[0] <== m2e.out[0];
    out[1] <== m2e.out[1];
}

template Pedersen(n) {
    signal input in[n];
    signal output out[2];

    var BASE[10][2] = [
        [7688621503272331394947188562469131124099290577812125474996268020905176040083,6637287939860384587467947982369268811366630904563077767287326262235485629411],
        [11549681895645637778324638856880330712650895608496649854094912415387988201330,5771732722784528537721081267383956005090479808901717812009343940574217488577],
        [18790245153471844934157747708238883966079935875787657036767664036124524381945,18300275459419441151064576487317481499516933849631632883767173501999997278432],
        [16301069151422548986850494139112207641738464387919729729324473657161689764196,8215273507373494014441104012907835625670941526105528197815397741007626226499],
        [12597665704678284488008395353749282149622295037737374782196049599390683534185,4072455241781501621593714139281767473040087753548015968773801065193764079468],
        [4729410576230735258214831208080552588881894465489299233097088872252465832672,14367731890670510422926552586486424937476635415639602730590517235570020260326],
        [7546420686025050869200393054526306477146836870617678274607971529534032974471,8663210466512842901413293603100781938253817808912549776944118491282484711929],
        [6544653022506992755201027646251976600601201151329001772892901529509137954387,5932506509962692832681604586561215780097326378431958035490245111470435106811],
        [12376274813795671622507230443130412169480807188767687554607910279743333852725,10116389110458158800073166533660211332390835019644001845057351607297889034557],
        [18268098112071835140361074835791174816144587762778386397940339415400583397725,8120955462199046866292537174552276799123029303901205157708576578886090835495]
    ];

    var nSegments = ((n-1)\200)+1;

    component segments[nSegments];

    var i;
    var j;
    var nBits;
    var nWindows;
    for (i=0; i<nSegments; i++) {
        nBits = (i == (nSegments-1)) ? n - (nSegments-1)*200 : 200;
        nWindows = ((nBits - 1)\4)+1;
        segments[i] = Segment(nWindows);
        segments[i].base[0] <== BASE[i][0];
        segments[i].base[1] <== BASE[i][1];
        for (j = 0; j<nBits; j++) {
            segments[i].in[j] <== in[i*200+j];
        }
        // Fill padding bits
        for (j = nBits; j < nWindows*4; j++) {
            segments[i].in[j] <== 0;
        }
    }

    component adders[nSegments-1];

    for (i=0; i<nSegments-1; i++) {
        adders[i] = BabyAdd();
        if (i==0) {
            adders[i].x1 <== segments[0].out[0];
            adders[i].y1 <== segments[0].out[1];
            adders[i].x2 <== segments[1].out[0];
            adders[i].y2 <== segments[1].out[1];
        } else {
            adders[i].x1 <== adders[i-1].xout;
            adders[i].y1 <== adders[i-1].yout;
            adders[i].x2 <== segments[i+1].out[0];
            adders[i].y2 <== segments[i+1].out[1];
        }
    }

/*
    coponent packPoint = PackPoint();

    if (nSegments>1) {
        packPoint.in[0] <== adders[nSegments-2].xout;
        packPoint.in[1] <== adders[nSegments-2].yout;
    } else {
        packPoint.in[0] <== segments[0].out[0];
        packPoint.in[1] <== segments[0].out[1];
    }

    out[0] <== packPoint.out[0];
    out[1] <== packPoint.out[1];
*/

    if (nSegments>1) {
        out[0] <== adders[nSegments-2].xout;
        out[1] <== adders[nSegments-2].yout;
    } else {
        out[0] <== segments[0].out[0];
        out[1] <== segments[0].out[1];
    }
}

