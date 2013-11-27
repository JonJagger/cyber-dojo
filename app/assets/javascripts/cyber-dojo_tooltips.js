/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.tipSettings = function() {
    return {
      cancelDefault: true,
      predelay: 500,
      effect: 'toggle',
      position: 'top right',
      offset: [20,0],
      relative: true,
      delay: 0  
    };
  };
  
  return cd;
})(cyberDojo || {}, $);

