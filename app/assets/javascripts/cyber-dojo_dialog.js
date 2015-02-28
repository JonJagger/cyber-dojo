/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };

  cd.dialog = function(html, title, close) {
    var buttons = { };
    buttons[close] = function() { $(this).remove(); };
    return $('<div>')
      .html(html)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        width: $(html).data("width"),
        height: $(html).data("height"),
        modal: true,
        buttons: buttons
      });
  };

  return cd;
})(cyberDojo || {}, $);
