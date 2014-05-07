/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.makeNavigateButtons = function(avatarName) {

	var makeNavigateButton = function(name) {
	  return '' +
		'<button class="triangle button"' +
			 'id="' + name + '_button">' +
		  '<img src="/images/triangle_' + name + '.gif"' +
			  ' alt="move to ' + name + ' diff"' +
			  ' width="20"' +
			  ' height="20" />' +
		'</button>';
	};

	return '' +
		'<table id="diff-navigate-buttons">' +
		  '<tr>' +
			'<td>' +
			   makeNavigateButton('first') +
			'</td>' +
			'<td>' +
			   makeNavigateButton('prev') +
			'</td>' +
			'<td>' +
			  '<img height="38"' +
			      ' width="38"' +
			      ' src="/images/avatars/' + avatarName + '.jpg"/>' +
			'</td>' +
			'<td>' +
			   makeNavigateButton('next') +
			'</td>' +
			'<td>' +
			   makeNavigateButton('last') +
			'</td>' +
		  '</tr>' +
		'</table>';
  };

  return cd;
})(cyberDojo || {}, $);
