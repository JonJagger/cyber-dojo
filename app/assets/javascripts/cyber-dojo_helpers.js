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

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.centeredDiv = function(node) {
    var div = $('<div>', {
     align: 'center'
    });
    div.append(node);
    return div;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.avatarImage = function(avatarName, imageSize) {
    return $('<img>', {
       alt: avatarName,
      'height': imageSize,
      'width': imageSize,
       src: "/images/avatars/" + avatarName + ".jpg",
       title: avatarName
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.fakeFilenameButton = function(filename) {
    return cd.makeTable(''
      + '<div class="filename selected">'
      +   '<input style="display:none;"'
      +         ' type="radio"'
      +         ' checked="checked"'
      +         ' value="filename"/>'
      +   '<label>' + filename + '</label>'
      + '</div>');
  };

  return cd;
})(cyberDojo || {}, $);
