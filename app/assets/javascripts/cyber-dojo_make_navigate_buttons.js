/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.makeNavigateButtons = function(avatarName) {
	  
	var makeNavigateButton = function(name) {	
	  return '' +
		'<button class="triangle button"' +
			 'id="' + name + '_button">' +
		  '<img src="/images/triangle_' + name + '.gif"' +
			   'alt="move to ' + name + ' diff"' +                 
			   'width="25"' + 
			   'height="25" />' +
		'</button>';      
	};	

	return '' +
	  '<div class="panel">' +
		'<table class="align-center">' +
		  '<tr>' +
			'<td>' +
			   makeNavigateButton('first') +
			'</td>' +
			'<td>' +
			   makeNavigateButton('prev') +
			'</td>' +
			'<td>' +
			  '<img height="42"' +
			      ' width="42"' +
			      ' src="/images/avatars/' + avatarName + '.jpg"/>' +
			'</td>' +
			'<td>' +
			   makeNavigateButton('next') +
			'</td>' +
			'<td>' +
			   makeNavigateButton('last') +
			'</td>' +
		  '</tr>' +
		'</table>' +
	  '</div>';
  };			

  return cd;
})(cyberDojo || {}, $);

