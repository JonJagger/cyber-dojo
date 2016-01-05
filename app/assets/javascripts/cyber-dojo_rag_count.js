/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.ragCount = function(lights, colour) {
    var count = 0;
    lights.each(function(_, node) {
      if ($(node).data('colour') == colour  ) {
        count += 1;
      }
    });
    return count;
  };

  return cd;

})(cyberDojo || {}, $);
