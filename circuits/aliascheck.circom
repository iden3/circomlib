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
pragma circom 2.2.0;

include "comparators.circom";

function maxbits(){
    var n = 1;
    var r = 1;
    while(2 * n > n){
        n = n * 2;
        r = r + 1;
    }
    return r + 1;
}


function num2bits_function(n, nBits) {
    var bits[maxbits()];
    var acc = n;

    for (var i = 0; i < nBits; i++) {
        bits[i] = acc % 2;
        acc = acc \ 2; // In Circom, \ performs integer division
    }

    return bits;
}


template AliasCheck(){

   // First we bitify the value of p-1. As it is a constant, we call to the auxiliar function to_bits
   var bits = maxbits();
   var p_to_bits[bits] = num2bits_function(-1, bits);

   signal input in[bits];
   
   
   // consider the most significant bit and open the first group
   var prev_bit = p_to_bits[0];
   var sum_group = in[0];
   var size_window = 1;
   
   var num_conds = 0;
   
   signal conds[bits];
   
   
   for (var i = 1; i < bits; i++){
      if (prev_bit == p_to_bits[i]){
         // does not change the bit, continue in the same group. We update the sum adding the new value
         sum_group += in[i];
         size_window += 1;
      }
      
      else{
         // the bit changes, we close the previous group adding the condition and open a new window
         if (prev_bit == 0){
            // we close a window of 0s
            if (size_window > 1){
               conds[num_conds] <== IsZero()(sum_group);
            } else{
               conds[num_conds] <== 1 - sum_group;
            }
         } else{
            // we close a window of 1s
            if (size_window > 1){
               conds[num_conds] <== IsEqual()([sum_group, size_window]);
            } else{
               conds[num_conds] <== sum_group;
            }
         }
         
         num_conds += 1;

         // we open the new window
         prev_bit = p_to_bits[i];
         sum_group = in[i];
         size_window = 1;
      }

   }
   
   // Finally we close the last window
   if (prev_bit == 0){
      // we close a window of 0s
      if (size_window > 1){
         conds[num_conds] <== IsZero()(sum_group);
      } else{
         conds[num_conds] <== 1 - sum_group;
      }

      num_conds += 1;
     
   } else{
      // we close a window of 1s
      if (size_window > 1){
         conds[num_conds] <== IsEqual()([sum_group, size_window]);
      } else{
         conds[num_conds] <== sum_group;
      }
      
      num_conds += 1;

   }


   // Now we generate the condition stating that the in should be smaller or equal than p-1
   signal acum_result[num_conds];
   prev_bit = p_to_bits[0];

   if (prev_bit == 0){ // number with first window being a 0
      acum_result[0] <== 1 - conds[0];
      prev_bit = 1;
   } else if (prev_bit == 1){
      acum_result[0] <== conds[0];
      prev_bit = 0;
   }

   var index = 1;


   while(index < num_conds){
      if (prev_bit == 0){ // number with last window being a 0
         acum_result[index] <== (1 - conds[index]) + acum_result[index-1] ;
         prev_bit = 1;
      } else if (prev_bit == 1){
         acum_result[index] <== conds[index] * acum_result[index-1];
         prev_bit = 0;
      }
      index += 1;
   }
   
   // We add the condition stating that the result should be <= p-1
   acum_result[num_conds - 1] === 0;


}