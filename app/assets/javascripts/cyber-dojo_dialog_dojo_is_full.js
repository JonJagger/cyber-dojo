/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_dojoIsFull = function(id) {
    
    var avatarTd = function(avatarName) {
      var size = 60;
      return ''
        + '<td class="panel" align="center">'
        + "  <input type='image'"
        + "         class='avatar_image'"
        + '         src="/images/avatars/' + avatarName + '.jpg"'
        + '         title="' + avatarName + ' has started"'
        + '         width="' + size + '"'
        + '         height="' + size + '"/>'
        + '  <div>'
        +      avatarName
        + '  </div>'
        + '</td>';      
    };

    var fullHtml = '' 
      + '<div align="center">'
      + '  <div id="full_dojo">Sorry, ' + id + ' is full!</div>'
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
    
    return $('<div class="dialog">')
      .html(fullHtml)
      .dialog({
        autoOpen: false,
        width: 600,
        modal: true,
        buttons: {
          ok: function() {
            $(this).dialog('close');
          }
        }
      });
  };
    
  return cd;
})(cyberDojo || {}, $);
