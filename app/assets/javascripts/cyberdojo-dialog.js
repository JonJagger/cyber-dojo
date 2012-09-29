/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.dialog = function(html,width,name) {
    var div = $j('<div>')
      .html('<div style="font-size: 1.2em;">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: '<h1>' + name + '</h1>',
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



