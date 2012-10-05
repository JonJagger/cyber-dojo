/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_dashboard_tips = function() {

    var traffic_light = function(colour) {
        return  '<img src="/images/traffic-light-' +colour + '.png"' +
                    ' width="20"' +
                    ' height="60"/> ';
    };
    
    var progression = function(from,to,activity) {
      return $cd.divPanel(
        'Look for ' + traffic_light(from) + '&rarr;' + traffic_light(to) +
        'progressions as evidence of ' + activity + '.'
      );        
    };

    var redFirst = progression('red',   'green', 'starting with a failing test');
    var refactor = progression('green', 'green', 'refactoring');
    var amber    = progression('amber', 'amber', 'overly ambitious steps');

    var dashboard = $j($cd.makeTable(redFirst,refactor,amber));
      
    $cd.dialog(dashboard.html(), 450, 'tips');
  };

  return $cd;
})(cyberDojo || {}, $);



