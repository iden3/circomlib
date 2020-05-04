# Sparse Merkle Trees

## Definition

A **Merkle tree** or hash tree is an authenticated data structure where every leaf node of 
the tree contains the cryptographic hash of a data block and every non leaf node contains 
the concatenated hashes of its child nodes [[1]](https://eprint.iacr.org/2018/955). 
If the majority of the leaves are empty, then they are called **sparse Merkle trees** 
[[2]](https://eprint.iacr.org/2016/683).

## Motivation 

Merkle trees allow to link a set of data to a unique has value, providing a secure and efficient 
verification of large data sets by storing only a little piece of data on-chain. 
For instance, they can be used to verify any kind of data stored, handled and transferred in and 
between computers. 
They can help ensure that data blocks received from other peers in a peer-to-peer network are 
received undamaged and unaltered, and even to check that the other peers do not lie and send fake 
blocks [[3]](https://books.google.es/books?id=aYxSZurAGXEC). 

## Terminology

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

## Description

Let `e=(k,v)` be a new entry in a tree `T`. The node in which this piece of data `e` is stored in `T` 
is uniquely determined from the data itself. 
Let _H_ be a secure hash function returning an array of bits. 
The leaf in which `e` should be stored in `T` is defined by 
`H_path = H(e) = H(1 || k || v)`.

This array of bits is going to represent a path through the tree: starting by the less significant bit 
and from the root of `T`,
it descents the tree by taking the left edge if there is a 0 and right one if there is a 1.

When adding an entry `e`, we may not go down to the last level of the tree (by last we mean looking at 
all the bits, length of which depends on the hash function _H_). What we do instead, is go down through 
the path until we find a node without siblings (a leaf). 
If the leaf is empty, we store `e`. 
Otherwise, that node stores some other `e'` (as non-empty leafs store claims) with `H(e') = H'_path`. 
This means that `H_path` and `H'_path` start with the same sequence of bits. 
We compare both hashes and go down the tree until the first different bit is found. 
Then we store `e` and `e'` in their corresponding leafs of the path.

## Example

As an example, consider `e` such that `H_path=0111111...` and the Merkle tree below where in each leaf 
there is represented the value (and not the key) of each stored piece of data:

![](https://i.imgur.com/MO4o5X7.png)

If we go down the tree following the sequence `01111111...` we get to the leaf containing the value 
`0704eaec` of some `e'` with `H'_{path}=0111110...`. 
Comparing `H_path` and `H'_path`, the 7th bit is the first different bit. This means, that we 
should go down to the 7th level and store there the entries as shown in next figure:

![](https://i.imgur.com/hlLGLbi.png)

Note that `e` is stored in the right (as the 7th bit is a 1) and `e'` is stored in the left (as it is a 0). 
Also note that the rest of siblings are empty nodes and how the root and intermediate nodes have changed.

## Remark

Each node is of the form `H[b, k, v]`, where `b = 1` if terminal node (leaf) and `b = 0` otherwise. 
More precisely,
- Each leaf consists of a pair `(H(1 || k || v), k||v)`.
- Each intermediate node of a pair `(H(H_L||H_R), K_L||K_R)`, where `(H_L,K_L)` is the key-value of 
its left child and `(H_L,K_L)` the key-value of its right child.

## Algorithms

#### Store an entry

Pseudocode: Insert Entry `e` in Merkle Tree `T` with Root `r`.

```
H_path<-GetPath(e)
b<-LSB(H_Index)
if (r is empty) then r<-e
else
    while r is internal vertex do
    if (b==0) then r <-LeftChild(r)
    else r<-RightChild(r)
    if r is empty then
        r<-e
        H_index<-(H_index\b)
        b<-LSB(H_index)
e'<-GenEntryStoredIn(r)
H'_path<-GetPath(e')
if (H_path != H'_path) then
    Find first bit b_j such that H_path(j) != H'_path(j)
    Leaf(b_0...b_j)<-e
    Leaf(b_0...b_j')<-e'
    ReculateIntermediateNodeValues(T)
```

#### Delete an entry

#### Update the tree

#### Generate membership proof

#### Generate non-membership proof

## Security 

The  security  of  an  audit  path  reduces  to  the  collision 
resistance  of the underlying hash function [[4, Lemma 1]](https://eprint.iacr.org/2016/683). 

## Bibliography

[1] https://eprint.iacr.org/2018/955

[2] https://eprint.iacr.org/2016/683

[3] https://books.google.es/books?id=aYxSZurAGXEC

[4] https://eprint.iacr.org/2016/683
