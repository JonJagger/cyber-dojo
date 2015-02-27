/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_enter = function(id, avatarName, dialogHtml) {
    var i18nButtons =  { };
    i18nButtons['ok'] = function() {
      var url = '/kata/edit/' + id + '?' +
                'avatar=' + avatarName;
      window.open(url);
      $(this).dialog('close');
    };
    return $('<div class="dialog">')
      .html(dialogHtml)
      .dialog({
        title: cd.dialogTitle('enter'),
        autoOpen: false,
        width: 350,
        modal: true,
        buttons: i18nButtons
      });
  };

  return cd;
})(cyberDojo || {}, $);
