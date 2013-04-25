/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_reviewCoding = function(id, dialogHtml) {
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        autoOpen: false,
        width: 550,
        title: cd.dialogTitle(id),
        modal: true,
        buttons: {
          ok: function() {
            cd.get('/dashboard/show', { id: id }, '_blank');            
            $(this).dialog('close');
          }, // ok:
          cancel: function() {
            $(this).dialog('close');            
          } // cancel:
        } // buttons:
      }); // .dialog({      
  }; // function() {
  
  return cd;
})(cyberDojo || {}, $);
