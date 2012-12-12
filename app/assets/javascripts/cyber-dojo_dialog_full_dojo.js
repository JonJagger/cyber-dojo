/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_fullDojo = function(title, id) {
    var grid = $('<div>');
    grid.load('/dojo/full_avatar_grid', { id: id }, function() {
      var resumer = $('<div class="dialog">')
        .html(grid.html())
        .dialog({
          autoOpen: false,
          title: cd.dialogTitle('!' + title),
          width: 600,
          modal: true,
          buttons: {
            ok: function() {
              $(this).dialog('close');
            }
          }
        });
      resumer.dialog('open');
    });
  };
    
  return cd;
})(cyberDojo || {}, $);
