/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_dojoIsEmpty = function(id) {
    
    var avatarTd = function(avatarName) {
      var size = 60;
      return ''
        + '<td class="panel">'
        + '  <img src="/images/avatars/bw/' + avatarName + '.jpg"'
        + '       title="' + avatarName + ' has not started"'
        + '       width="' + size + '"'
        + '       height="' + size + '"/>'
        + '  <div class="unstarted-avatar-name">'
        +      avatarName
        + '  </div>'
        + '</td>';      
    };
    
    var message = ''
      + 'Cannot resume an animal<br/>'
      + 'because the dojo is empty';
      
    var emptyHtml = '' 
      + '<div data-width="600">'
      + '  <div id="empty_dojo_text">' + message + '</div>'
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
    return cd.dialog(emptyHtml, title);
  };

  return cd;
})(cyberDojo || {}, $);
