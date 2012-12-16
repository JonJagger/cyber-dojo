/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_noId = function() {
    var noId = 
      '<div class="panel">'
      + '<table>'
      +    '<tr>'
      +      '<td>'
      +        'Click'
      +          ' <div id="setup" class="button">setup</div> '
      +        'to get a new id.<br/>'
      +        '<br/>'
      +        'A full id is always 10 characters long, '
      +        'contains only the digits 0123456789 '
      +        'and letters ABCDEF, and is case insensitive.<br/>'
      +        '<br/>'
      +        'You usually only need to enter the '
      +        'first 5 characters of an id.'      
      +      '</td>'
      +    '</tr>'
      +  '</table>'
      + '</div>';
    var width = 400;
    return cd.dialog(noId, width, '');    
  };

  return cd;
})(cyberDojo || {}, $);
