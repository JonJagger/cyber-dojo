/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_reviewCoding = function(id, ok, dialogHtml) {
    var i18nButtons = { };
    i18nButtons[ok] = function() {
      cd.get('/dashboard/show', { id: id }, '_blank');            
      $(this).dialog('close');      
    };
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        autoOpen: false,
        width: 550,
        title: cd.dialogTitle(id),
        modal: true,
        buttons: i18nButtons
      }); 
  };
  
  return cd;
})(cyberDojo || {}, $);
