/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.tipSettings = function() { // TODO: AIM TO DROP
    return {
      cancelDefault: true,
      predelay: 500,
      effect: 'toggle',
      position: 'top right',
      offset: [20,0],
      relative: true,
      delay: 0  
    };
  };
  
  cd.tipify = function(nodes) {
    var tipWindow = $('#tipWindow');
    $.each(nodes, function(_,node) {      
      var timer;
      $(node).on('mouseenter', function(event) {
        // For some reason, the diff-traffic-light is
        // showing event.target as the inner <img> rather
        // than the outer div???  Hack work-around is
        // to find for the tooltip inside the parent
        var parent = $(event.target).parent();
        var tip = $('.tooltip', parent);        
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

