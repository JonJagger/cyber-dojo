/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.reEnter = function(id, avatarName) {
    var url = '/kata/edit/' + id + '?avatar=' + avatarName;
    window.open(url);
    cd.closeReEnterDialog();
    return false;
  };

  //- - - - - - - - - - - - - - - - - - - - -
  
  cd.dialog_reEnter = function(title, cancel ,dialogHtml) {
    var buttons = { };
    buttons[cancel] = function() { $(this).dialog('close'); };
    var reEnter = $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: 420,
        modal: true,
        buttons: buttons
      });
    cd.closeReEnterDialog = function() { reEnter.dialog('close'); };
    return reEnter;
  };

  return cd;
})(cyberDojo || {}, $);
