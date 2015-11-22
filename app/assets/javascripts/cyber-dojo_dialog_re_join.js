/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.reJoin = function(id, avatarName) {
    var url = '/kata/edit/' + id + '?avatar=' + avatarName;
    window.open(url);
    cd.closeReJoinDialog();
    return false;
  };

  //- - - - - - - - - - - - - - - - - - - - -

  cd.dialog_reJoin = function(title, cancel ,dialogHtml) {
    var buttons = { };
    buttons[cancel] = function() { $(this).dialog('close'); };
    var reJoin = $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: 500,
        modal: true,
        buttons: buttons
      });
    cd.closeReJoinDialog = function() { reJoin.dialog('close'); };
    return reJoin;
  };

  return cd;
})(cyberDojo || {}, $);
