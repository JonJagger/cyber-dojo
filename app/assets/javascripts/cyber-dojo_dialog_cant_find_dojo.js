/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_cantFindDojo = function(id, ok) {
    var cantFindDojo = 
      '<div class="panel" data-width="400">'
      + '<table>'
      +    '<tr>'
      +      '<td>'
      +        "I can't find a cyber-dojo with that id."
      +      '</td>'
      +    '</tr>'
      +  '</table>'
      + '</div>';
    var title = id + '?';
    return cd.dialog(cantFindDojo, title, ok);
  };

  return cd;
})(cyberDojo || {}, $);
