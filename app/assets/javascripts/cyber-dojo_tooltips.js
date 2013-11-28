/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.tipify = function(nodes) {
    var tipWindow = $('#tip_window');
    $.each(nodes, function(_,node) {      
      var timer;
      $(node).on('mouseenter', function(event) {
        // For some reason, the diff-traffic-light is
        // showing event.target as the inner <img> rather
        // than the outer <div>!?  Hack work-around is
        // to find for the tooltip inside the parent.
        var target = $(event.target);
        var tip = target.children().first();
        if (tip.length === 0) {
          tip = $('.tooltip', target.parent());
        }        
        timer = setTimeout(function() {
          tipWindow.html(tip.html());
          tipWindow.show();
        }, 750);
      });
      
      $(node).on('mouseleave', function(e) {
        tipWindow.hide();
        tipWindow.empty();
        clearTimeout(timer);
      });
    });
  };
    
  return cd;
})(cyberDojo || {}, $);

