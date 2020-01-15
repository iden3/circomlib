/*
 * This file is a part of ABDK Base CIRCOM Library.
 * Copyright © 2019 by ABDK Consulting (https://abdk.consulting/).
 * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
 */
 
/**
 * Abort witness calculation (or compilation in some cases) in case given
 * condition is not met.
 *
 * @param condition condition to check, any non-zero value means that condition
 *        is met
 */
function assert (condition) {
  if (condition == 0) {
    var x = 0;
    x = x \ 0;
  }
}
