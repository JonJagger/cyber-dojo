/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_startCoding = function(id, avatarName) {
    var size = 120;
    var avatarImage = '' 
      + '<div align="center">' 
      +   '<div class="medium">your animal is the</div>' 
      +   '<img class="avatar_image"' 
      +        'src="/images/avatars/' + avatarName + '.jpg"' 
      +        'width="' + size + '"' 
      +        'height="' + size + '"/>' 
      +    '<div align="center">' 
      +      '<div class="medium">' + avatarName + '</div>' 
      +    '</div>' 
      + '</div>';
      
    return $('<div class="dialog">')
      .html(avatarImage)
      .dialog({
        autoOpen: false,
        width: 400,
        modal: true,
        buttons: {
          ok: function() {
            cd.postTo('/kata/edit', { id: id, avatar: avatarName  }, '_blank');      
            $(this).dialog('close');
          } // ok:
        } // buttons:
      }); // .dialog({
  }; // function() {
  
  return cd;
})(cyberDojo || {}, $);

