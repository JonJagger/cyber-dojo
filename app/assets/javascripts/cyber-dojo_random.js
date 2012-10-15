/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.randomAlphabet = function() {
    return '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';  
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.randomChar = function() {
    var alphabet = cd.randomAlphabet();
    return alphabet.charAt(cd.rand(alphabet.length));
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.random3 = function() {
    return cd.randomChar() + cd.randomChar() + cd.randomChar();
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.rand = function(n) {
    return Math.floor(Math.random() * n);
  };

  return cd;
})(cyberDojo || {}, $);



