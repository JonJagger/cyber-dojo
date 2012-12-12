/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_resumeCoding = function(title, id) {
    var grid = $('<div>');
    grid.load('/dojo/resume_avatar_grid', { id: id }, function() {
      var resumer = $('<div id="resume_coding_dialog">')
        .html('<div class="dialog">' + grid.html() + '</div>')
        .dialog({
          autoOpen: false,
          title: cd.dialogTitle(title),
          width: 600,
          modal: true,
          buttons: {
            cancel: function() {
              $(this).dialog('close');
            }
          }
        });
      cd.registerCloseResumeDialog(resumer);
      resumer.dialog('open');
    });
  };

  cd.registerCloseResumeDialog = function(resumer) {
    cd.closeResumeDialog = function() {
      resumer.dialog('close');
    };
  };
  
  return cd;
})(cyberDojo || {}, $);
