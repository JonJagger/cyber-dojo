/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.id = function(name) {
    return $('[id="' + name + '"]');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.inArray = function(find, array) {
    return $.inArray(find, array) !== -1;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.node = function(name, content) {
    return '<'+name+'>'
          +  content
	        +'</'+name+'>';
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeTable = function() {
    var i, max, content = '';
    for (i = 0, max = arguments.length; i < max; i += 1) {
      content += cd.node('td', arguments[i]);
    }
    return cd.node('table', cd.node('tr', content));
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.td = function(html) {
	  return cd.node('td',html);
  };

  return cd;

})(cyberDojo || {}, $);
