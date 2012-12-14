/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_dojoIsFull = function(id) {
    var grid = $('<div>');
    grid.load('/dojo/full_avatar_grid', { id: id }, function() {
      var resumer = $('<div class="dialog">')
        .html(grid.html())
        .dialog({
          autoOpen: false,
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
