/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };

  cd.dialog = function(html, title, close) {
    var i18nButtons = { };
    i18nButtons[close] = function() {
      $(this).remove();
    };
    return $('<div>')
      .html(html)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: $(html).data("width"),
        height: $(html).data("height"),
        modal: true,
        buttons: i18nButtons
      });
  };

  return cd;
})(cyberDojo || {}, $);
