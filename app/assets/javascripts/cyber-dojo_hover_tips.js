/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var showTrafficLightHoverTipViaAjax = function(light) {
    $.getJSON('/tipper/traffic_light_tip', {
           id: light.data('id'),
       avatar: light.data('avatar-name'),
      was_tag: light.data('was-tag'),
      now_tag: light.data('now-tag')
    }, function(response) {
      cd.showHoverTip(light, response.html);
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

  var getTrafficLightCountHoverTip = function(node) {
    var avatarName = node.data('avatar-name');
    var reds = node.data('red-count');
    var ambers = node.data('amber-count');
    var greens = node.data('green-count');
    var timeOuts = node.data('timed-out-count');
    return avatarName + ' has<br/>' + countHoverTipHtml(reds, ambers, greens, timeOuts);
  };

  // - - - - - - - - - - - - - - - - - - - -

  cd.setupHoverTip = function(nodes) {
    nodes.each(function() {
      var node = $(this);
      var tip = node.data('tip');
      var setTipCallBack = function() {
        if (tip == 'ajax:traffic_light') {
          showTrafficLightHoverTipViaAjax(node);
        } else if (tip == 'traffic_light_count') {
          cd.showHoverTip(node, getTrafficLightCountHoverTip(node));
        } else {
          cd.showHoverTip(node, tip);
        }
      };
      cd.setTip(node, setTipCallBack);
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  cd.setTip = function(node, setTipCallBack) {
    node.mouseenter(function() {
      node.removeClass('mouse-has-left');
      setTipCallBack();
    });
    node.mouseleave(function() {
      node.addClass('mouse-has-left');
      $('.hover-tip', node).remove();
    });
  };

  // - - - - - - - - - - - - - - - - - - - -

  cd.showHoverTip = function(node, tip) {
    // mouseenter may retrieve the tip via a slow ajax call
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

  return cd;

})(cyberDojo || {}, $);
