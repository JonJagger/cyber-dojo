/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.XmakeNavigateButtons = function() {

	var makeNavigateButton = function(name) {
	  var size = (name === 'first' || name === 'last') ? 20 : 30;
	  return '' +
		'<button class="triangle button"' +
			 'id="' + name + '_button">' +
		  '<img src="/images/triangle_' + name + '.gif"' +
			  ' alt="move to ' + name + ' diff"' +
			  ' width="' + size + '"' +
			  ' height="' + size + '" />' +
		'</button>';
	};

	return '' +
		'<table id="navigate-buttons">' +
		  '<tr>' +
			cd.td(makeNavigateButton('first')) +
			cd.td(makeNavigateButton('prev')) +
			cd.td(makeNavigateButton('next')) +
			cd.td(makeNavigateButton('last')) +
		  '</tr>' +
		'</table>';
  };

  return cd;
})(cyberDojo || {}, $);
