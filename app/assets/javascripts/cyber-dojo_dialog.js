/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialogTitle = function(title) {
    return '<span class="large dialog title">' + title + '<span>';
  };
  
  cd.dialog = function(html, width, title) {
    // ignore width if explicitly specified in data-size attribute of top element (e.g. <table data-width="550">)
    // the idea is to keep the formatting with the html, instead of 'polluting' the controller with it
    width = $(html).data("width") || width;

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
