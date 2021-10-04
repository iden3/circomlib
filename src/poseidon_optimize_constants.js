const fs = require("fs");
const path = require("path");
const Scalar = require("ffjavascript").Scalar;
const ZqField = require("ffjavascript").ZqField;
const { unstringifyBigInts } = require("ffjavascript").utils;


// Version to write in  hexadecimal
function stringifyBigInts(o) {
    if ((typeof(o) == "bigint") || o.eq !== undefined)  {
        return "0x"+o.toString(16);
    } else if (o instanceof Uint8Array) {
        return Scalar.fromRprLE(o, 0);
    } else if (Array.isArray(o)) {
        return o.map(stringifyBigInts);
    } else if (typeof o == "object") {
        const res = {};
        const keys = Object.keys(o);
        keys.forEach( (k) => {
            res[k] = stringifyBigInts(o[k]);
        });
        return res;
    } else {
        return o;
    }
}

const { C, M } = unstringifyBigInts(require("./poseidon_constants.json"));

const N_ROUNDS_F = 8;
const N_ROUNDS_P = [56, 57, 56, 60, 60, 63, 64, 63, 60, 66, 60, 65, 70, 60, 64, 68];


function matrix_inverse(Fr, A) {
    const m = A.length;
    const B=[];
    for (let i=0; i<m; i++) {
        if (A[i].length != m) throw new Error("Matrix is not square");
        B[i] = [];
        for (let j=0; j<m; j++) B[i][j] = A[i][j];
        for (let j=0; j<m; j++) B[i][m+j] = i==j ? Fr.one : Fr.zero;
    }
    const n=2*m;
    let h=0;  // curRow
    let k=0; // curColumn

    // Triangularize
    while ((h<m)&&(k<n)) {
        // Find the pivot
        let i_max;
        for (i_max=h; (i_max<m)&&(Fr.isZero(B[i_max][k])); i_max++);
        if (i_max==m) throw new Error("Matrix is not inveritible");

        [B[h], B[i_max]] = [B[i_max], B[h]];

        const inv_pivot = Fr.inv(B[h][k]);

        for (let i=h+1; i<m; i++) {
            const f = Fr.mul(B[i][k], inv_pivot);
            B[i][k] = Fr.zero;
            for (let j=k+1; j<n; j++) B[i][j] = Fr.sub(B[i][j], Fr.mul(B[h][j], f)); 
        }

        B[h][k] = Fr.one;
        for (let j=k+1; j<n; j++) B[h][j] = Fr.mul(B[h][j], inv_pivot); 
        h++;
        k++;
    }

    for (let i=m-2; i>=0; i--) {
        for (let i2=i+1; i2<m; i2++) {
            const f = B[i][i2];
            for (let k=m; k<n; k++) B[i][k] = Fr.sub(B[i][k], Fr.mul(f,B[i2][k]));
            B[i][i2] = Fr.zero;
        }
    }

    for (let i=0; i<m; i++) {
        B[i] = B[i].slice(-m);
    }
    return B;
}

function matrix_print(Fr, A) {
    for (let i=0; i<A.length; i++) {
        let S = "";
        for (let j=0;j<A[i].length; j++) {
            if (j>0) S = S + ", ";
            S = S + Fr.toString(A[i][j]);
        }
        console.log(S);
    }
}

function vec_print(Fr, v) {
    for (let i=0; i<v.length; i++) {
        console.log(Fr.toString(v[i]));
    }
}

function vec_mul_matrix(Fr, v, A) {
    checkSquare(A);
    if (v.length != A.length) throw new Error("Invalid vec mul sizes");
    const res = [];
    for (let j=0; j<v.length; j++) {
        res[j] = Fr.zero;
        for (let i=0; i<A.length; i++) {
            res[j] = Fr.add(res[j], Fr.mul(v[i], A[i][j]));
        }
    }
    return res;
}

function matrix_mul_vec(Fr, A, v) {
    checkSquare(A);
    if (v.length != A.length) throw new Error("Invalid vec mul sizes");
    const res = [];
    for (let i=0; i<v.length; i++) {
        res[i] = Fr.zero;
        for (let j=0; j<A.length; j++) {
            res[i] = Fr.add(res[i], Fr.mul(A[i][j], v[j]));
        }
    }
    return res;
}

function matrix_mul(Fr, A, B) {
    checkSquare(A);
    if (A.length != B.length) throw new Error("multiplication different sizes");
    const res = [];
    for (let i=0; i<A.length; i++) {
        res[i] = [];
        for (let j=0; j<A.length; j++) {
            res[i][j] = Fr.zero;
        }
    }
    for (let i=0; i<A.length; i++) {
        for (let j=0; j<A.length; j++) {
            for (let k=0; k<A.length; k++) {
                res[i][j] = Fr.add( res[i][j],  Fr.mul(A[i][k], B[k][j])   );
            }
        }
    }

    return res;
}

function matrix_traspose(A) {
    checkSquare(A);
    const res = [];
    for (let i=0; i<A.length; i++) {
        res[i] = [];
        for (let j=0; j<A.length; j++) {
            res[i][j] = A[j][i];
        }
    }
    return res;
}

function checkSquare(A) {
    const n= A.length;
    for (let i=0; i<A.length; i++) {
        if (A[i].length != n) throw new Error("Matrix is not square");
    }
}



function convertConstants(Fr, t, C, M) {
    let res = [];
    const nRoundsF = N_ROUNDS_F;
    const nRoundsP = N_ROUNDS_P[t - 2];

    const Minv = matrix_inverse(Fr, M);

    for (let k=0; k<t; k++) res.push(C[k]);

    for (let r=0; r<nRoundsF/2-1; r++) {
        const cr = C.slice((r+1)*t, (r+1)*t+t);
        const crt = vec_mul_matrix(Fr, cr, Minv);
        for (let k=0; k<t; k++) res.push(crt[k]);
    }

    const partialConst = [];
    let acc = [];
    for (let k=0; k<t; k++) acc[k] = C[(nRoundsF/2+ nRoundsP -1 +1)*t+k];

    for (let r=nRoundsF/2+nRoundsP-1; r>=nRoundsF/2; r--) {
        const accp = vec_mul_matrix(Fr, acc, Minv);
        partialConst.push(accp[0]);
        accp[0] = Fr.zero;
        for (let k=0; k<t; k++) acc[k] = Fr.add(accp[k], C[(r-1+1)*t+k]);
    }

    const accp = vec_mul_matrix(Fr, acc, Minv);
    for (let k=0; k<t; k++) res.push(accp[k]);

    for (let i=0; i<partialConst.length; i++) res.push(partialConst[partialConst.length-1-i]);

    for (let r=nRoundsF/2 + nRoundsP; r< nRoundsF+nRoundsP-1; r++) {
        const cr = C.slice((r+1)*t, (r+1)*t+t);
        const crt = vec_mul_matrix(Fr, cr, Minv);
        for (let k=0; k<t; k++) res.push(crt[k]);
    }

    return res;
}
/*
                m_{0,0}     m_{0,1}     m_{0,2}   ...........   m_{0,t-1}
                w_0         1           0         ...........   0
                w_1         0           1         ...........   0
                .           .           .            .          .
                .           .           .                .      .
                w_{t-2}     0           0         ...........   1
*/
// Returns sparse matrix with format: [m_{0,0}, m_0, ..... m_{t-2}, m_{0,1}, ... m_{0, t-1}]

function sparseFactorize(Fr, m) {

    const m_hat = [];
    const mp = [];
    const w = [];
    for (let i=0; i<m.length; i++) {
        mp[i] = [];
        if (i<m.length-1) m_hat[i] = [];
        for (let j=0; j<m.length; j++) {
            if ((i>0) &&(j>0)) {
                m_hat[i-1][j-1] = m[i][j];
                mp[i][j] = m[i][j];
            } else {
                mp[i][j] = ((i==0)&&(j==0)) ? Fr.one : Fr.zero; 
            }
            if ((i>0)&&(j==0)) w[i-1] = m[i][j];
        }
    }
    const m_hat_inv = matrix_inverse(Fr, m_hat);
    const wp = matrix_mul_vec(Fr, m_hat_inv, w);

    const S = [];

    S.push(m[0][0]);
    for (let k=0; k<wp.length; k++) S.push(wp[k]);
    for (let k=1; k<m.length; k++) S.push(m[0][k]);

    return [mp, S];
}

function calculatePS(Fr, t, M) {
    const nRoundsP = N_ROUNDS_P[t - 2];
    const sparse = [];
    let m=M;

    for (let i=0; i<nRoundsP; i++) {
        const [mp, mpp] = sparseFactorize(Fr, m);
        sparse.push(mpp);
        m = matrix_mul(Fr, M, mp);
    }
    const P = m;
    const S = [];

    for (let i=0; i<sparse.length; i++) {
        for (let k=0; k<sparse[sparse.length-1-i].length; k++) {
            S.push(sparse[sparse.length-1-i][k]);
        }
    }

    return [P, S];
}


async function run() {
    // Prime bn128
    const Fr = new ZqField(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

    let opt = {
        C: [],
        M: [],
        P: [],
        S: []
    };
    for (let i=1; i<=16; i++) {
        const oM = matrix_traspose(M[i-1]); 
        const oC =  convertConstants(Fr, i+1, C[i-1], oM);
        const [oP, oS] = calculatePS(Fr, i+1, oM);
        opt.C.push(oC);
        opt.M.push(oM);
        opt.P.push(oP);
        opt.S.push(oS);
    }

    opt = stringifyBigInts(opt);

    fs.writeFileSync(path.join(__dirname, "poseidon_constants_opt.json"), JSON.stringify(opt, null, 1), "utf8");
}

run().then(()=> {
    process.exit(0);
}, (err) => {
//    console.log(err);
    console.log(err.stack);
    process.exit(1);
});