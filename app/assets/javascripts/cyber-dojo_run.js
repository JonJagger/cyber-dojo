/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.run = function(id, method, func) {
    $.getJSON('/dojo/' + method, { id: id }, function(data) {
      func(data);
    });
  };

  return cd;
})(cyberDojo || {}, $);



