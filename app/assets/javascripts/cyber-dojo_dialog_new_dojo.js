/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.newDojoDialog = function(title, id, okCallBack) {
    var html = '' +
      "<div class='align-center'>" +
        "<div style='font-size:1.0em;'>" +
          "your practice session's id is" +
        '</div>' +
        "<div class='avatar-background'>" +
          "<span class='centerer'></span>" +
          "<span class='dojo-id'>" +
            id.substring(0,6) +
          '</span>' +
        "</div>" +
      "</div>";
    return $('<div>')
      .html(html)
      .dialog({
        title: cd.dialogTitle(title),
        autoOpen: false,
        modal: true,
        width: 435,
        closeOnEscape: true,
        close: function() {
          okCallBack(id);
          $(this).remove();
        },
        buttons: {
          ok: function() {
            okCallBack(id);
            $(this).remove();
          }
        }
    });
  };

  return cd;

})(cyberDojo || {}, $);
