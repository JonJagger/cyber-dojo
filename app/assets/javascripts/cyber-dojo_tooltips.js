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
  
  cd.tipify = function(node) {
	var tipWindow = $('#tipWindow');
	var timer;
	node.on('mouseenter', function(event) {
	  var tip = $(event.target).children().first();
	  timer = setTimeout(function() {
		tipWindow.html(tip.html());
		tipWindow.show();
	  }, 750);
	});
	
	node.on('mouseleave', function(e) {
	  tipWindow.hide();
	  tipWindow.empty();
	  clearTimeout(timer);
	});	
  };
  
  return cd;
})(cyberDojo || {}, $);

