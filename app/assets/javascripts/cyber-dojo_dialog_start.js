/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_start = function(title, id, avatarName, dialogHtml) {
    var okOrCancel = function() {
      var url = '/kata/edit/' + id + '?avatar=' + avatarName;
      window.open(url);
    };
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: 435,
        modal: true,
        closeOnEscape: true,
        close: function() {
          okOrCancel();
          $(this).remove();
        },
        buttons: {
          ok: function() {
            okOrCancel();
            $(this).remove();
          }
        }
      });
  };

  return cd;
})(cyberDojo || {}, $);
