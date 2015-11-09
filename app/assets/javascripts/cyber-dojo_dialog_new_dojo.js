/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.newDojoDialog = function(title, id) {
    var html = '' +
      "<div class='align-center'>" +
        "<div style='font-size:1.5em;'>" +
          "your new cyber-dojo's id is" +
        '</div>' +
        "<div style='font-size:2.5em;'>" +
            id.substring(0,6) +
        '</div>' +
      "<div class='avatar-background'></div>" +
      "</div>";
    return $('<div>')
      .html(html)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        modal: true,
        width: 435,
        buttons: {
          ok: function() {
            var url = '/dojo/index/' + id;
            window.open(url);
            $(this).remove();
          }
        }
    });
  };

  return cd;

})(cyberDojo || {}, $);
