/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.reJoin = function(id, avatarName) {
    var url = '/kata/edit/' + id + '?avatar=' + avatarName;
    window.location.href = url;
  };

  // Used on the enter page by the [continue], [dashboard], and [review] buttons.
  cd.continueDialog = function(title, dialogHtml) {
    var buttons = { };
    buttons['cancel'] = function() { $(this).dialog('close'); };
    $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: true,
        width: 500,
        modal: true,
        buttons: buttons
      });
  };

  return cd;

})(cyberDojo || {}, $);
