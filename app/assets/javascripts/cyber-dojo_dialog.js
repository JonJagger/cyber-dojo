/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };
  
  cd.dialog = function(html, title, ok) {
    var i18nButtons = { };
    i18nButtons[ok] = function() {
      $(this).dialog('close');      
    };
    return $('<div>')
      .html('<div class="dialog">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: $(html).data("width"),
        height: $(html).data("height"),
        title: cd.dialogTitle(title),
        modal: true,
        buttons: i18nButtons
      });
  };

  return cd;
})(cyberDojo || {}, $);
