/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.reEnter = function(id, avatarName) {
    var url = '/kata/edit/' + id + '?' +
              'avatar=' + avatarName;
    window.open(url);
    cd.closeReEnterDialog();
    return false;
  };

  //- - - - - - - - - - - - - - - - - - - - -
  
  cd.dialog_reEnter = function(title, cancel ,dialogHtml) {
    var i18nButtons = { };
    i18nButtons[cancel] = function() {
      $(this).dialog('close');
    };
    var reEnter = $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: 500,
        modal: true,
        buttons: i18nButtons
      });
    cd.closeReEnterDialog = function() {
      reEnter.dialog('close');
    };
    return reEnter;
  };

  return cd;
})(cyberDojo || {}, $);
