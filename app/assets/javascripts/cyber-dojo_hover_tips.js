/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var setTip = function(node,tip) {
    // mouseenter retrieves the tip via a slow ajax call
    // which means mouseleave could have already occurred
    // by the time the ajax returns to set the tip. The
    // mouse-has-left attribute minimizes this race's chance.
    if (!node.hasClass('mouse-has-left')) {
      node.append($('<span class="hover-tip">' + tip + '</span>'));
      // dashboard auto-scroll requires forced positioning.
      $('.hover-tip').position({
        my: 'left top',
        at: 'right',
        of: node });
    }
  };

  var setAjaxTrafficLightTip = function(light) {
    $.getJSON('/tipper/traffic_light_tip', {
      id: light.data('id'),
      avatar: light.data('avatar-name'),
      was_tag: light.data('was-tag'),
      now_tag: light.data('now-tag')
    }, function(response) {
      setTip(light,response.html);
    });
  };

  var setAjaxTrafficLightCountTip = function(node) {
    $.getJSON('/tipper/traffic_light_count_tip', {
      avatar: node.data('avatar-name'),
      bulb_count: node.data('bulb-count'),
      current_colour: node.data('current-colour')
    }, function(response) {
      setTip(node,response.html);
    });
  };

  cd.setupHoverTips = function() {
    $('[data-tip]').each(function() {
      var node = $(this);
      var tip = node.data('tip');
      node.mouseleave(function() {
        node.addClass('mouse-has-left');
        $('.hover-tip',node).remove();
      });
      node.mouseenter(function() {
        node.removeClass('mouse-has-left');
        if (tip === 'ajax:traffic_light') {
          setAjaxTrafficLightTip(node);
        } else if (tip === 'ajax:traffic_light_count') {
          setAjaxTrafficLightCountTip(node);
        } else {
          setTip(node,tip);
        }
      });
    });
  };

  return cd;

})(cyberDojo || {}, $);
