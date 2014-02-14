/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.resume = function(id, avatarName) {
    var url = '/kata/edit/' + id + '?' +
              'avatar=' + avatarName;
    window.open(url);
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
