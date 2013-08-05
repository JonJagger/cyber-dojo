/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_dojoIsFull = function(id, ok) {
    
    var avatarTd = function(avatarName) {
      var size = 60;
      return ''
        + '<td class="panel">'
        + '  <img src="/images/avatars/' + avatarName + '.jpg"'
        + '       title="' + avatarName + ' has already started"'
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
      + '<div data-width="600">'
      + '  <div class="align-center" id="full_dojo_text">' + message + '</div>'
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
    
    var title = id;
    return cd.dialog(fullHtml, title, ok);
  };
    
  return cd;
})(cyberDojo || {}, $);
