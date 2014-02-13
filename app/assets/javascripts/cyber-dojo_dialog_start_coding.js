/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_startCoding = function(title, id, ok, avatarName, dialogHtml) {
    var i18nButtons =  { };
    i18nButtons[ok] = function() {
      cd.postTo('/kata/edit', { id: id, avatar: avatarName  }, '_blank');      
      $(this).dialog('close');    
    };
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),        
        autoOpen: false,
        width: 350,
        modal: true,
        buttons: i18nButtons
      });      
  };
  
  return cd;
})(cyberDojo || {}, $);

