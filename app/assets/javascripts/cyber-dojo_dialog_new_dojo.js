/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.newDojoDialog = function(id) {
    var goToEnterPage = function() {
      var url = '/enter/show/' + id;
      window.location = url;
    };

    var html = '' +
      "<div class='align-center'>" +
        "<div style='font-size:1.0em;'>" +
          'your new id is' +
        '</div>' +
        "<div class='avatar-background'>" +
          "<span class='centerer'></span>" +
          "<span class='dojo-id'>" +
            id.substring(0,6) +
          '</span>' +
        '</div>' +
      '</div>';

    $('<div>')
      .html(html)
      .dialog({
        title: cd.dialogTitle('create&nbsp;a&nbsp;practice&nbsp;session'),
        autoOpen: true,
        modal: true,
        width: 435,
        closeOnEscape: true,
        close: function() {
          goToEnterPage();
          $(this).remove();
        },
        buttons: {
          ok: function() {
            goToEnterPage(id);
            $(this).remove();
          }
        }
      });
  };

  return cd;

})(cyberDojo || {}, $);
