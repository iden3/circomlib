# Sparse Merkle Trees

The templates of this folder contain the logic of sparse Merkle trees. More precisely, the template [`smt_processor`](smt_processor) allows to insert, update and delete elements of the tree, and the template [`smt_verifier`](smt_verifier) checks if an element is included or not in a tree.

## Structure

- [`smt_processor`](smt_processor)
- [`smt_verifier`](smt_verifier)

## Background

A Merkle tree is an authenticated data structure where every leaf node of the tree contains the cryptographic hash of a data block and every non leaf node contains the concatenated hashes of its child nodes \cite{compact}. If the majority of the leaves are empty, then these trees are called sparse Merkle trees \cite{security-mt}. 

These trees are very useful for storing pairs of key-value and 

A Merkle tree is a data structure that Merkle trees give us a way to cryptographically commit to a set of data. We start by hashing each piece of data in the set, and then keep hashing our way up the tree until we get to the root node.

These structures give us a way to link a set of data to a unique hash value, the root of the tree. 
This way, 
This is very useful, as it provides a secure and efficient verification of large data sets by storing only a little piece of data, the root of the tree, which is lik to the whole set of data. 

### Terminology

- The leaves of the Merkle tree consist of key-value pairs `(k,v)`. We distinguish three different 
nodes:
    - **Empty node**: A vertex that stores the key and value zero.
    - **Leaf**: A vertex with both empty children.
    - **Internal node**: A vertex with at least one non-empty child. The value is and the key such. 
    It has the hash of its children.
- A **Merkle audit path** for a leaf in a Merkle tree is the shortest list of additional nodes in the 
tree required to compute the root hash for that tree.
- If the root computed from the audit path matches the true root, then the audit path is a **proof 
of membership** for that leaf in the tree.
- Otherwise, it is a **proof of non-membership** for that leaf in the tree. 

![](https://i.imgur.com/hD4RitU.png)

Merkle trees allow to link a set of data to a unique has value, the root of the tree, 
which is very optimal and useful, specially in blockchain technology, as it provides a secure and efficient verification of large data sets by storing only a little piece of data on-chain. 

These structures are very useful to commit to a set of data, 
(Sparse) Merkle trees allow to link a set of data to a unique has value, which is very optimal and useful, specially in blockchain technology, as it provides a secure and efficient verification of large data sets by storing only a little piece of data on-chain. 

A sparse Merkle tree is like a standard Merkle tree, except the contained data is indexed, and each datapoint is placed at the leaf that corresponds to that datapoint’s index.

The root of this tree is just a hash — it tells us nothing about the contents of the tree. We can use something called a “Merkle proof” to show that some content is actually part of this tree. For example, let’s prove that A is part of the above tree. All we need to do is provide each of A’s siblings on the way up, recompute the tree, and make sure everything matches

Sparse Merkle trees (SMT) are data structures useful for storing pairs of key-value.


maps which works as follows.

An empty SMT is simply a Merkle tree with 2256 leaves, where every leaf is a zero value. Because every element at the second level of the tree is the same ( z2=hash(0,0) ), and every element at the third level is the same ( z3=hash(z2,z2) ) and so forth this can be trivially computed in 256 hashes. From there, we can add or remove values by modifying values in place in the sparse Merkle tree, eg. to add the value 42 at position 3, we modify the second value the second level to v2=hash(0,42) , the first value at the third level to v3=hash(0,v2) , the first value at the fourth level to v2=hash(v3,z3) (since at this point, the left subtree represents keys 0…3 and the right subtree represents keys 4…7 which are still all empty), and so forth up to the top.

We don’t need to store any level in a literal array; we can simply store a hash map of parent→(leftchild,rightchild) , and in general the map will grow by at most 256 elements for each item we add into the tree. Adding, updating or removing any element takes 256 steps, and a Merkle proof of an element takes 256 hashes, if done naively.

Sparse Merkle trees are conceptually elegant in their extreme simplicity; from a mathematical perspective, they really are just Merkle trees. In simplest form, the get function is literally ten lines of code:

Spare Merkle trees 
Blabla about sparse Merkle trees ... .

* https://ethresear.ch/t/optimizing-sparse-merkle-trees/3751
* https://medium.com/@kelvinfichter/whats-a-sparse-merkle-tree-acda70aeb837
* https://blog.iden3.io/sparse-merkle-trees-visual-introduction.html
* https://blog.iden3.io/merkle-trees-visual-introduction.html

Files but these two descriptions:

### Actions on the leafs
- Insert
- Update
- Delete

### Proofs of membership
- Proof of membership
- Proof of non-membership




Talk about js and test.

### Circuit implementation: SMT Processor

If so.

### Insert to an empty leaf

```

  STATE                 OLD STATE                                       NEW STATE
  =====                 =========                                       =========

                         oldRoot                                          newRoot
                            ▲                                               ▲
                            │                                               │
          ┌───────┐     ┏━━━┻━━━┓                         ┌───────┐     ┏━━━┻━━━┓
   top    │Sibling├────▶┃ Hash  ┃◀─┐                      │Sibling├────▶┃ Hash  ┃◀─┐
          └───────┘     ┗━━━━━━━┛  │                      └───────┘     ┗━━━━━━━┛  │
                                   │                                               │
                                   │                                               │
                               ┏━━━┻━━━┓   ┌───────┐                           ┏━━━┻━━━┓   ┌───────┐
   top                  ┌─────▶┃ Hash  ┃◀──┤Sibling│                    ┌─────▶┃ Hash  ┃◀──┤Sibling│
                        │      ┗━━━━━━━┛   └───────┘                    │      ┗━━━━━━━┛   └───────┘
                        │                                               │
                        │                                               │
        ┌───────┐   ┏━━━┻━━━┓                           ┌───────┐   ┏━━━┻━━━┓
   top  │Sibling├──▶┃ Hash  ┃◀─────┐                    │Sibling├──▶┃ Hash  ┃◀─────┐
        └───────┘   ┗━━━━━━━┛      │                    └───────┘   ┗━━━━━━━┛      │
                                   │                                               │
                                   │                                               │
                              ┌────┴────┐                                     ┌────┴────┐
  old0                        │    0    │                                     │New1Leaf │
                              └─────────┘                                     └─────────┘


                     ┏━━━━━━━┓                                      ┏━━━━━━━┓
   na                ┃ Hash  ┃                                      ┃ Hash  ┃
                     ┗━━━━━━━┛                                      ┗━━━━━━━┛


                     ┏━━━━━━━┓                                      ┏━━━━━━━┓
   na                ┃ Hash  ┃                                      ┃ Hash  ┃
                     ┗━━━━━━━┛                                      ┗━━━━━━━┛
```


### Insert to a used leaf.

```
  STATE                 OLD STATE                                       NEW STATE
  =====                 =========                                       =========


                         oldRoot                                          newRoot
                            ▲                                               ▲
                            │                                               │
          ┌───────┐     ┏━━━┻━━━┓                         ┌───────┐     ┏━━━┻━━━┓
   top    │Sibling├────▶┃ Hash  ┃◀─┐                      │Sibling├────▶┃ Hash  ┃◀─┐
          └───────┘     ┗━━━━━━━┛  │                      └───────┘     ┗━━━━━━━┛  │
                                   │                                               │
                                   │                                               │
                               ┏━━━┻━━━┓   ┌───────┐                           ┏━━━┻━━━┓   ┌───────┐
   top                  ┌─────▶┃ Hash  ┃◀──┤Sibling│                    ┌─────▶┃ Hash  ┃◀──┤Sibling│
                        │      ┗━━━━━━━┛   └───────┘                    │      ┗━━━━━━━┛   └───────┘
                        │                                               │
                        │                                               │
        ┌───────┐   ┏━━━┻━━━┓                           ┌───────┐   ┏━━━┻━━━┓
   top  │Sibling├──▶┃ Hash  ┃◀─────┐                    │Sibling├──▶┃ Hash  ┃◀─────┐
        └───────┘   ┗━━━━━━━┛      │                    └───────┘   ┗━━━━━━━┛      │
                                   │                                               │
                                   │                                               │
                              ┌────┴────┐                                      ┏━━━┻━━━┓   ┌───────┐
   bot                        │Old1Leaf │                               ┌─────▶┃ Hash  ┃◀──┼─  0   │
                              └─────────┘                               │      ┗━━━━━━━┛   └───────┘
                                                                        │
                                                                        │
                     ┏━━━━━━━┓                          ┌───────┐   ┏━━━┻━━━┓
   bot               ┃ Hash  ┃                          │   0  ─┼──▶┃ Hash  ┃◀─────┐
                     ┗━━━━━━━┛                          └───────┘   ┗━━━━━━━┛      │
                                                                                   │
                                                                                   │
                     ┏━━━━━━━┓                                                 ┏━━━┻━━━┓   ┌───────┐
   bot               ┃ Hash  ┃                                          ┌─────▶┃ Hash  ┃◀──│   0   │
                     ┗━━━━━━━┛                                          │      ┗━━━━━━━┛   └───────┘
                                                                        │
                                                                        │
                     ┏━━━━━━━┓                        ┌─────────┐   ┏━━━┻━━━┓   ┌─────────┐
  new1               ┃ Hash  ┃                        │Old1Leaf ├──▶┃ Hash  ┃◀──│New1Leaf │
                     ┗━━━━━━━┛                        └─────────┘   ┗━━━━━━━┛   └─────────┘


                     ┏━━━━━━━┓                                      ┏━━━━━━━┓
   na                ┃ Hash  ┃                                      ┃ Hash  ┃
                     ┗━━━━━━━┛                                      ┗━━━━━━━┛


                     ┏━━━━━━━┓                                      ┏━━━━━━━┓
   na                ┃ Hash  ┃                                      ┃ Hash  ┃
                     ┗━━━━━━━┛                                      ┗━━━━━━━┛

```

Fnction
fnc[0]  fnc[1]
0       0             NOP
0       1             UPDATE
1       0             INSERT
1       1             DELETE


***************************************************************************************************/

## References

[[1]](https://tools.ietf.org/html/rfc8032)  S. Josefsson and I. Liusvaara, *Edwards-Curve Digital Signature Algorithm (EdDSA)*. RFC 8032, January 2017.

[[2]](http://ed25519.cr.yp.to/eddsa-20150704.pdf)  D.J. Bernstein, S. Josefsson, T. Lange, P. Schwabe and Bo-Yin Yang, *EdDSA for more curves*. July 2015.



@misc{compact,
	author = {Faraz Haider},
	title = {Compact Sparse Merkle Trees},
	howpublished = {Cryptology ePrint Archive, Report 2018/955},
	year = {2018},
	note = {\url{https://eprint.iacr.org/2018/955}},
}