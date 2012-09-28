/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.popup = function(name) {
    var grid = $j('<div>');
    grid.load('/dojo/' + name, { }, function() {
      var div = $j('<div>')
        .html('<div style="font-size: 1.2em;">' + grid.html() + '</div>')    
        .dialog({
          autoOpen: false,
          width: (name === 'why' ? 1100 : 850),
          title: '<h1>' + name + '</h1>',
          modal: true,
          buttons: {
            ok: function() {
              $j(this).dialog('close');
            }
          }
        });
      div.dialog('open');        
    });  
  };

  return $cd;
})(cyberDojo || {}, $);



