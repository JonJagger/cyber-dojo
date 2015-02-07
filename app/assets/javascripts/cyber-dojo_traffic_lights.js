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

  var setTip = function(light,tip) {
    // mouseenter retrieves the tip via a slow ajax call
    // which means mouseleave could have already occurred
    // by the time the ajax returns to set the tip. The
    // mouse-has-left attribute minimizes this race's chance.
    if (!light.hasClass('mouse-has-left')) {
      light.append($('<span class="hover-tip">' + tip + '</span>'));
    }
    // Ah figgis. When the dashboard scrolls, the tooltip
    // is not in the correct place.
  };

  cd.setupTrafficLightToolTips = function(lights) {
    lights.each(function() {
      var light = $(this);
      var tip = light.data('tip');
      light.mouseleave(function() {
        light.addClass('mouse-has-left');
        $('.hover-tip',light).remove();
      });
      light.mouseenter(function() {
        light.removeClass('mouse-has-left');
        if (tip === 'ajax:traffic_light') {
          $.getJSON('/tipper/tip', {
            id: light.data('id'),
            avatar_name: light.data('avatar-name'),
            was_tag: light.data('was-tag'),
            now_tag: light.data('now-tag')
          }, function(response) {
            setTip(light,response.html);
          });
        } else {
          setTip(light,tip);
        }
      });
    });
  };

  return cd;

})(cyberDojo || {}, $);
