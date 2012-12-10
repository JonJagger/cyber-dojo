/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };
  
  cd.dialog = function(html, width, name) {
    var div = $('<div>')
      .html('<div class="dialog">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: cd.dialogTitle(name),
        modal: true,
        buttons: {
          ok: function() {
            $(this).dialog('close');
          }
        }
      });
    div.dialog('open');            
  };

  return cd;
})(cyberDojo || {}, $);
