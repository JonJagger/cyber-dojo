/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.run = function(method, func) {    
    var dojoId = $('#kata_id_input').attr('value');
    dojoId = $.trim(dojoId);
    if (dojoId === '') {
      cd.dialog_noId().dialog('open');
    }
    else {
      $.getJSON('/dojo/' + method + '/?id=' + dojoId, function(dojo) {
        if (!dojo.exists) {
          cd.dialog_cantFindDojo(dojoId).dialog('open');
        }
        else {
          func(dojoId, dojo);
        }
      });
    }
  };

  return cd;
})(cyberDojo || {}, $);



