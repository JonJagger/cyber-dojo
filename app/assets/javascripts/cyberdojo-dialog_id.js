/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.dialog_id = function(language,exercise,kuid) {
    var id = $j(
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
      
    $cd.dialog(id.html(), 350, 'id');
  };

  return $cd;
})(cyberDojo || {}, $);



