/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_startCoding = function(id, avatarName, dialogHtml) {      
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        autoOpen: false,
        width: 350,
        modal: true,
        buttons: {
          ok: function() {
            cd.postTo('/kata/edit', { id: id, avatar: avatarName  }, '_blank');      
            $(this).dialog('close');
          } // ok:
        } // buttons:
      }); // .dialog({      
  }; // function() {
  
  return cd;
})(cyberDojo || {}, $);

