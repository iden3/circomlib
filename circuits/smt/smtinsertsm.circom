/***************************************************************************************************
Each level on a SMTInsert has a state.

The state of the level depends on the state of te botom level and on `xor` and
`is0` signals.

`isOldLev` 1 when is the level where oldLeaf is.

`xor` signal is 0 if the index bit at the current level is the same in the old
and the new index, and 1 if it is different.

`is0` signal, is 1 if we are inserting in an empty leaf and 0 if we are inserting
in a leaf that contains an element.

The states are:

top: While the index bits of the old and new insex in the top level is the same, whe are in the top state.
old0 and old1: When the we reach insert level,  we go to old0 and old1 states
according to `is0` signal.
btn: Once in old1 we go to btn until xor=1
new1: This level is reached when xor=1. Here is where we insert the hash of the
old and the new trees with just one element.
na: Not appliable.  After inserting it, we go to the na level.



                                                ###########
                     levIns==curLevel          #           #
   xor=0                  is0=1 ┌────────────▶#    old0     #────────┐
  ┌─────┐                       │              ##         ##         │
  │     │                       │                #########           │ any
  │     ▼                       │                                    │
  │    ###########              │                                    │          ###########
  │   #           # ────────────┘                                    └────────▶#           #
  └──#    top      #                                                          #    na       #
      ##         ## ────┐                                                  ┌──▶##         ##
        #########       │                                                  │     #########
                        │                                                  │
                        │      ###########                  ###########    │ any
       levIns==curLevel │     #           #      xor=1     #           #   │
            is0=0       └───▶#   old1      #─────────────▶#    new1     #──┘
                              ##         ##                ##         ##
                                #########──┐                 #########
                                           │                     ▲
                                           │               ┌─────┘
                                      any  │    ###########│  xor=1
                                           │   #           #
                                           └─▶#    btn      #
                                               ##         ##
                                                 #########◀───────┐
                                                     │            │
                                                     │            │
                                                     └────────────┘
                                                         xor=0

***************************************************************************************************/

state
