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
  
  cd.dialog_resumeCoding = function(id, dialogHtml) {
    var resumer = $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        autoOpen: false,
        width: 500,
        title: cd.dialogTitle(id),
        modal: true,
        buttons: {
          cancel: function() {
            $(this).dialog('close');
          }
        }
      });
    cd.closeResumeDialog = function() {
      resumer.dialog('close');
    };    
    return resumer;
  };
  
  return cd;
})(cyberDojo || {}, $);
