/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.rand = function(n) {
    return Math.floor(Math.random() * n);
  };

  return cd;
})(cyberDojo || {}, $);
