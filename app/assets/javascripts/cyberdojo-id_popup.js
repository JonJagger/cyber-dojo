/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.idPopup = function(language,exercise,kuid) {
    var grid = $j(
      $cd.makeTable(
      '<div class="panel">' +
        '<div>' +
          'language: ' + language +
        '</div>' +
        '<div>' +        
          'exercise: ' + exercise +
        '</div>' +
        '<div>' +        
          'kuid: ' + kuid +
        '</div>' +
      '</div>'));
      
    var div = $j('<div>')
      .html('<div style="font-size: 1.2em;">' + grid.html() + '</div>')    
      .dialog({
        autoOpen: false,
        width: 350,
        title: '<h1>id</h1>',
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



