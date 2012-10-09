/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.id = function(name) {
    return $j('[id="' + name + '"]');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.inArray = function(find, array) {
    return $j.inArray(find, array) !== -1;    
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.makeTable = function() {
    var makeTd = function(arg) {
      return '<td>' + arg + '</td>';
    };    
    var i, max;
    var table = '<table><tr>';
    for (i = 0, max = arguments.length; i < max; i += 1) {
      table += makeTd(arguments[i]);
    }
    table += '</tr></table>';
    return table;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.centeredDiv = function(node) {
    var div = $j('<div>', {
     align: 'center' 
    });
    div.append(node);
    return div;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.avatarImage = function(avatar_name, imageSize) {
    return $j('<img>', {
       alt: avatar_name,
      'class': "avatar_image",
      'height': imageSize,
      'width': imageSize,
       src: "/images/avatars/" + avatar_name + ".jpg",
       title: avatar_name
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.htmlPanel = function(content) {
    return '<div class="panel" style="font-size: 2.0em;">' + content + '</div>';
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.divPanel = function(content) {
    return '<div class="panel">' + content + '</div>';
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.h1 = function(title) {
    return '<h1>' + title + '</h1>';  
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.fakeFilenameButton = function(filename) {
    return $cd.makeTable(''
      + '<div class="filename" style="background:Cornsilk;color:#003C00;">'
      +   '<input style="display:none;"'
      +         ' type="radio"'
      +         ' name="filename' + filename + '"'
      +         ' checked="checked"'
      +         ' value="filename"/>'
      +   '<label>' + filename + '</label>'
      + '</div>');
  };
  
  return $cd;
})(cyberDojo || {}, $);



