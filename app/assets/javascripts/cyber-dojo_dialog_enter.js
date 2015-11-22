/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_enter = function(id, avatarName, dialogHtml) {
    var okOrCancel = function() {
      var url = '/kata/edit/' + id + '?avatar=' + avatarName;
      window.open(url);
    };
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle('join'),
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
