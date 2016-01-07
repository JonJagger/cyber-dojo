/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var setAjaxTrafficLightHoverTip = function(light) {
    $.getJSON('/tipper/traffic_light_tip', {
      id: light.data('id'),
      avatar: light.data('avatar-name'),
      was_tag: light.data('was-tag'),
      now_tag: light.data('now-tag')
    }, function(response) {
      cd.setHoverTip(light, response.html);
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  var countHoverTipHtml = function(reds, ambers, greens, timeOuts) {
    var colourWord = function(colour, word) {
      return "<span class='" + colour + "'>" + word + '</span>';
    };
    var plural = function(count, colour) {
      var word = colour + (count == 1 ? '' : 's');
      return '<div>' + count + ' ' + colourWord(colour, word) + '</div>';
    };
    var html = '';
    if (reds     > 0) { html += plural(reds    , 'red'    ); }
    if (ambers   > 0) { html += plural(ambers  , 'amber'  ); }
    if (greens   > 0) { html += plural(greens  , 'green'  ); }
    if (timeOuts > 0) { html += plural(timeOuts, 'timeout'); }
    return html;
  };

  // - - - - - - - - - - - - - - - - - - - -

  var setTrafficLightCountHoverTip = function(node) {
    var avatarName = node.data('avatar-name');
    var redCount = node.data('red-count');
    var amberCount = node.data('amber-count');
    var greenCount = node.data('green-count');
    var timeOutCount = node.data('timed-out-count');
    var html = avatarName + ' has<br/>';
    html += countHoverTipHtml(redCount, amberCount, greenCount, timeOutCount);
    cd.setHoverTip(node, html);
  };

  // - - - - - - - - - - - - - - - - - - - -

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
        } else if (tip == 'traffic_light_count') {
          setTrafficLightCountHoverTip(node);
        } else {
          cd.setHoverTip(node, tip);
        }
      });
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  cd.setHoverTip = function(node, tip) {
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

  // - - - - - - - - - - - - - - - - - - - -

  cd.setTip = function(node, tip) {
    node.mouseenter(function() {
      node.removeClass('mouse-has-left');
      cd.setHoverTip(node, tip);
    });
    node.mouseleave(function() {
      node.addClass('mouse-has-left');
      $('.hover-tip', node).remove();
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  return cd;

})(cyberDojo || {}, $);
