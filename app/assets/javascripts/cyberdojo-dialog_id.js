/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.idPopup = function(language,exercise,kuid) {
    var grid = $j(
      $cd.makeTable(
        $cd.divPanel(
          '<div>' +
            'language: ' + language +
          '</div>' +
          '<div>' +        
            'exercise: ' + exercise +
          '</div>' +
          '<div>' +        
            'kuid: ' + kuid +
          '</div>'
        )
      )
    );
      
    $cd.dialogPopup(grid.html(), 350, 'id');
  };

  return $cd;
})(cyberDojo || {}, $);



