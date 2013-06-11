/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_dojoIsFull = function(id) {
    
    var avatarTd = function(avatarName) {
      var size = 60;
      return ''
        + '<td class="panel">'
        + '  <img src="/images/avatars/' + avatarName + '.jpg"'
        + '       title="' + avatarName + ' has started"'
        + '       width="' + size + '"'
        + '       height="' + size + '"/>'
        + '  <div class="started-avatar-name">'
        +      avatarName
        + '  </div>'
        + '</td>';      
    };
    
    var message = ''
      + 'Cannot start a new animal<br/>'
      + 'because the dojo is full';
      
    var fullHtml = '' 
      + '<div>'
      + '  <div id="full_dojo_text">' + message + '</div>'
      + '  <table class="align-center">'
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
    return cd.dialog(fullHtml, width = 600, title = id);
  };
    
  return cd;
})(cyberDojo || {}, $);
