/*jsl:option explicit*/

var cyberDojo = (function(cd, $) {
  
  cd.dialog = function(html,width,name) {
    var div = $('<div>')
      .html('<div class="dialog">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: cd.h2(name),
        modal: true,
        buttons: {
          ok: function() {
            $(this).dialog('close');
          }
        }
      });
    div.dialog('open');            
  };

  return cd;
})(cyberDojo || {}, $);
