/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var setHoverTip = function(node, tip) {
    // mouseenter retrieves the tip via a slow ajax call
    // which means mouseleave could have already occurred
    // by the time the ajax returns to set the tip. The
    // mouse-has-left attribute reduces this race's chance.
    if (!node.hasClass('mouse-has-left')) {
      node.append($('<span class="hover-tip">' + tip + '</span>'));
      // dashboard auto-scroll requires forced positioning.
      $('.hover-tip').position({
        my: 'left top',
        at: 'right bottom',
        of: node
      });
    }
  };

  var setAjaxTrafficLightHoverTip = function(light) {
    $.getJSON('/tipper/traffic_light_tip', {
      id: light.data('id'),
      avatar: light.data('avatar-name'),
      was_tag: light.data('was-tag'),
      now_tag: light.data('now-tag')
    }, function(response) {
      setHoverTip(light, response.html);
    });
  };

  var setAjaxTrafficLightCountHoverTip = function(node) {
    $.getJSON('/tipper/traffic_light_count_tip', {
      avatar: node.data('avatar-name'),
      bulb_count: node.data('bulb-count'),
      current_colour: node.data('current-colour'),
      red_count: node.data('red-count'),
      amber_count: node.data('amber-count'),
      green_count: node.data('green-count'),
      timed_out_count: node.data('timed-out-count')
    }, function(response) {
      setHoverTip(node, response.html);
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  var setSimpleReviewTrafficLightHoverTip = function(node) {
    var html = 'Review ' + node.data('was-tag') + '&harr;' + node.data('now-tag');
    setHoverTip(node, html);
  };

  // - - - - - - - - - - - - - - - - - - - -

  var setSimpleReviewTrafficLightCountHoverTip = function(node) {
    var colourTag = function(colour, tag) {
      return "<span class='" + colour + "'>" + tag + '</span>';
    };
    var pluralWord = function(word, count) {
      return word + (count == 1 ? '' : 's');
    };
    var pluralColour = function(count, colour) {
      var word = pluralWord(colour, count);
      return '<div>' + count + ' ' + colourTag(colour, word) + '</div>';
    };
    var timedOutCount= node.data('timed-out-count');
    var html =
      pluralColour(node.data('red-count'), 'red') +
      pluralColour(node.data('amber-count'), 'amber') +
      pluralColour(node.data('green-count'), 'green');

    if (timedOutCount > 0) {
      html += pluralColour(node.data('timed-out-count'), 'timout');
    }
    setHoverTip(node, html);
  };

  cd.setupHoverTip = function(nodes) {
    nodes.each(function() {
      var node = $(this);
      var tip = node.data('tip');
      node.mouseleave(function() {
        node.addClass('mouse-has-left');
        $('.hover-tip', node).remove();
      });
      node.mouseenter(function() {
        node.removeClass('mouse-has-left');
        if (tip == 'ajax:traffic_light') {
          setAjaxTrafficLightHoverTip(node);
        } else if (tip == 'ajax:traffic_light_count') {
          setAjaxTrafficLightCountHoverTip(node);
        } else if (tip == 'simple_review_traffic_light') {
          setSimpleReviewTrafficLightHoverTip(node);
        } else if (tip == 'simple_traffic_light_count') {
          setSimpleReviewTrafficLightCountHoverTip(node);
        } else {
          setHoverTip(node, tip);
        }
      });
    });
  };

  return cd;

})(cyberDojo || {}, $);
