/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.dialog = function(html,width,name) {
    var div = $j('<div>')
      .html('<div class="dialog">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: $cd.h1(name),
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    div.dialog('open');            
  };

  return $cd;
})(cyberDojo || {}, $);
