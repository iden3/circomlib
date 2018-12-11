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


Fnction
fnc[0]  fnc[1]
0       0             NOP
0       1             UPDATE
1       0             INSERT
1       1             DELETE



                                                ###########
                         levIns=1              #           #
  levIns=0                is0=1 ┌────────────▶#    old0     #────────┐                 any
  ┌─────┐                       │              ##         ##         │               ┌──────┐
  │     │                       │                #########           │ any           │      │
  │     ▼                       │                                    │               ▼      │
  │    ###########              │                                    │          ########### │
  │   #           # ────────────┘                                    └────────▶#           #│
  └──#    top      #                                                          #    na       #
      ##         ## ────┐                                                  ┌──▶##         ##
        #########       │                                                  │     #########
                        │                                                  │
                        │      ###########                  ###########    │ any
           levIns=1     │     #           #      xor=1     #           #   │
            is0=0       └───▶#   old1      #─────────────▶#    new1     #──┘
                              ##         ##                ##         ##
                                #########│                   #########
                                         │                       ▲
                                         └───┐             ┌─────┘
                                     xor=0   │  ###########│  xor=1
                                             │ #           #
                                             ▼#    btn      #
                                               ##         ##
                                                 #########◀───────┐
                                                     │            │
                                                     │            │
                                                     └────────────┘
                                                         xor=0

***************************************************************************************************/

template SMTInsertSM() {
  signal input xor;
  signal input is0;
  signal input levIns;
  signal input fnc[0];
  signal input fnc[1];

  signal input prev_top;
  signal input prev_old0;
  signal input prev_old1;
  signal input prev_bot;
  signal input prev_new1;
  signal input prev_na;
  signal input prev_upd;

  signal output st_top;
  signal output st_old0;
  signal output st_old1;
  signal output st_bot;
  signal output st_new1;
  signal output st_na;
  signal output st_upd;

  signal aux1;
  signal aux2;

  aux1 <== prev_top * levIns;
  aux2 <== aux1*is0;
  st_top <==  prev_top - aux1            // prev_top * (1-levIns) =
                                         //  = prev_top - aux1;
  st_old0 <== aux2 * fnc[0];                       // (prev_top * levIns * is0)*fnc[0] = aux2
  st_old1 <== (aux1 - aux2)*fnc[0];                // (prev_top * levIns * (1-is0))*fnc[0] =
                                                   //   = (aux1 * (1-is0))*fnc[0] =
                                                   //   = (aux1 - aux2) * fnc[0]
  st_new1 <== (prev_old1 + prev_bot)*xor     // prev_old1*xor + prev_bot*xor =
                                             //   = (prev_old1 + prev_bot)*xor;
  st_bot <== -st_new1 + prev_old1 + prev_bot // prev_old1*(1-xor) + prev_bot*(1-xor) =
                                             //  = - prev_old1*xor -prev_bot*xor + prev_old1 + prev_bot =
                                             //  = -st_new1 + prev_old1 + prev_bot
  st_na <== prev_new1 + prev_old0 + prev_na + st_upd;
  st_upd <== aux1*(1-fnc[0]);                // prev_top*levIns*(1-fnc[0]) =
                                             //   = aux1 * (1-fnc[0])

}
