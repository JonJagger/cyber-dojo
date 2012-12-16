/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };
  
  cd.dialog = function(html, width, title) {
    var div = $('<div>')
      .html('<div class="dialog">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: cd.dialogTitle(title),
        modal: true,
        buttons: {
          ok: function() {
            $(this).dialog('close');
          }
        }
      });
    return div;
  };

  return cd;
})(cyberDojo || {}, $);
