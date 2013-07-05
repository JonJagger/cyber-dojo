/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.hashOf = function(content) {
    var hash, i;
    for (hash = 0, i = 0; i < content.length; ++i) {
      hash = (hash << 5) - hash + content.charCodeAt(i);
      hash &= hash;
    }
    return hash;
  };  
  
  return cd;
})(cyberDojo || {}, $);



