/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_noId = function() {
    var noId = 
      '<div class="panel" data-width="400">'
      + '<table>'
      +    '<tr>'
      +      '<td>'
      +        'Click'
      +          ' <div id="setup" class="button">setup</div> '
      +        'to get a new id.<br/>'
      +      '</td>'
      +    '</tr>'
      +  '</table>'
      + '</div>';
    var title = '';
    return cd.dialog(noId, title);    
  };

  return cd;
})(cyberDojo || {}, $);
