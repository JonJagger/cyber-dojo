/*global jQuery,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_ie = function(yesAction) {
    if ($.browser.msie) {
      var html = "<div class='dialog'>" +
        "cyber-dojo is untested for Internet Explorer.<br/>" +
        "Do you wish to continue?" +
        "</div>";

      var buttons = { };
      buttons['yes'] = function() { yesAction(); $(this).dialog('close'); };
      buttons['no'] = function() { $(this).dialog('close'); };
      var warning = $('<div>')
        .html(html)
        .dialog({
          title: cd.dialogTitle('browser warning'),
          autoOpen: false,
          width: 500,
          modal: true,
          buttons: buttons
        });
      warning.dialog('open');
    } else {
      yesAction();
    }
  };

  return cd;
})(cyberDojo || {}, jQuery);
