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

  cd.setupTrafficLightCountOpensCurrentCode = function(bulbs,showRevert) {
    $.each(bulbs, function(_,bulb) {
      var count = $(bulb);
      var id = count.data('id');
      var avatarName = count.data('avatar-name');
      var wasTag = count.data('bulb-count');
      var nowTag = count.data('bulb-count');
      var lastTag = -1;
      var colour  = count.data('current-colour');
      if (colour === 'timed_out') {
        colour = 'amber';
      }
      var plural = function(count,name) {
        return count + ' ' + name + (count > 1 ? 's' : '');
      };
      var toolTip = avatarName + ' has ' + plural(wasTag, 'traffic-light') +
        ' and is at ' + colour + '.' +
        ' Click to review ' + avatarName + "'s current code.";
      count.attr('title', toolTip);
      count.click(function() {
        cd.dialog_history(id,avatarName,lastTag,lastTag,showRevert);
      });
    });
  };

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.setupTrafficLightToolTips = function(lights) {
    lights.hover(
      function() { // in
        var tip = $(this).data('tip');
        $(this).append($('<span class="hover-tip">' + tip + '</span>'));
      },
      function() { // out
        $(this).find('span:last').remove();
      }
    );
  };

  return cd;

})(cyberDojo || {}, $);
