/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_dojoIsEmpty = function(id) {
    
    var avatarTd = function(avatarName) {
      var size = 60;
      return ''
        + '<td class="panel" align="center">'
        + '  <img src="/images/avatars/bw/' + avatarName + '.jpg"'
        + '       title="' + avatarName + ' has not started"'
        + '       width="' + size + '"'
        + '       height="' + size + '"/>'
        + '  <div>'
        +      avatarName
        + '  </div>'
        + '</td>';      
    };
    
    var message = ''
      + 'Cannot resume an  animal<br/>'
      + 'because the dojo is empty';
      
    var emptyHtml = '' 
      + '<div align="center">'
      + '  <div id="empty_dojo_text">' + message + '</div>'
      + '  <table>'
      + '    <tr>'
      +        avatarTd('alligator')
      +        avatarTd('buffalo')
      +        avatarTd('cheetah')
      +        avatarTd('deer')
      + '    </tr>'
      + '    <tr>'
      +        avatarTd('elephant')
      +        avatarTd('frog')
      +        avatarTd('gorilla')
      +        avatarTd('hippo')
      + '    </tr>'
      + '    <tr>'
      +        avatarTd('koala')
      +        avatarTd('lion')
      +        avatarTd('moose')
      +        avatarTd('panda')
      + '    </tr>'
      + '    <tr>'
      +        avatarTd('raccoon')
      +        avatarTd('snake')
      +        avatarTd('wolf')
      +        avatarTd('zebra')
      + '    </tr>'
      + '  </table>'
      + '</div>';
    
    var width, title;
    return cd.dialog(emptyHtml, width = 600, title = id);
  };

  return cd;
})(cyberDojo || {}, $);
