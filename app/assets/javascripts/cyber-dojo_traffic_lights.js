/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.currentTrafficLightColour = function() {
    var count = $('.traffic-light-count');
    return count.data('current-colour');
  };

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.setupTrafficLightOpensHistoryDialogHandlers = function(lights,showRevert) {
    lights.click(function() {
      var light = $(this);
      var id = light.data('id');
      var avatarName = light.data('avatar-name');
      var wasTag = light.data('was-tag');
      var nowTag = light.data('now-tag');
      cd.dialog_history(id,avatarName,wasTag,nowTag,showRevert);
    });
  };

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.setupTrafficLightCountOpensCurrentCode = function(counts,showRevert) {
    counts.click(function() {
      var count = $(this);
      var id = count.data('id');
      var avatarName = count.data('avatar-name');
      var lastTag = -1;
      count.click(function() {
        cd.dialog_history(id,avatarName,lastTag,lastTag,showRevert);
      });
    });
  };

  return cd;

})(cyberDojo || {}, $);
