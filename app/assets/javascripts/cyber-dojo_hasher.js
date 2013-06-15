/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.hasher = function(str) {
    var hash, i;
    for (hash = 0, i = 0; i < str.length; ++i) {
      hash = (hash << 5) - hash + str.charCodeAt(i);
      hash &= hash;
    }
    return hash;
  };  
  
  return cd;
})(cyberDojo || {}, $);



