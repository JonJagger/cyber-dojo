/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.resume = function(id, avatarName) {
    cd.postTo('/kata/edit', {
      id: id,
      avatar: avatarName
    }, '_blank');  
    cd.closeResumeDialog();
    return false;    
  };
  
  cd.dialog_resumeCoding = function(title, cancel ,dialogHtml) {
    var i18nButtons = { };
    i18nButtons[cancel] = function() {
      $(this).dialog('close');      
    };
    var resumer = $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: 500,
        modal: true,
        buttons: i18nButtons
      });
    cd.closeResumeDialog = function() {
      resumer.dialog('close');
    };    
    return resumer;
  };
  
  return cd;
})(cyberDojo || {}, $);
