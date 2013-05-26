/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.run = function(method, func) {    
    var id = $('#kata_id_input').val();
    id = $.trim(id);
    if (id === '') {
      cd.dialog_noId().dialog('open');
    }
    else {
      $.getJSON('/dojo/' + method , { id: id }, function(dojo) {
        if (!dojo.exists) {
          cd.dialog_cantFindDojo(id).dialog('open');
        }
        else {
          func(id, dojo);
        }
      });
    }
  };

  return cd;
})(cyberDojo || {}, $);



