/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_cantFindDojo = function(title,id) {
    var cantFindDojo = 
      '<div class="panel">'
      + '<table>'
      +    '<tr>'
      +      '<td>'
      +        "I can't find a cyber-dojo with an id of"
      +        '<div id="cant_find_id">' + id + '</div>'
      +        "id's are always 10 characters long,<br/>"
      +        "are case sensitive, and contain only<br/>"
      +        "the digits 23456789 and letters ABCDEF"
      +      '</td>'
      +    '</tr>'
      +  '</table>'
      + '</div>';
    var width = 400;
    cd.dialog(cantFindDojo, width, '!'+title);
  };

  return cd;
})(cyberDojo || {}, $);
