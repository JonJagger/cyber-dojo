/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_dashboard_tips = function() {

    var traffic_light = function(colour) {
        return  '<img src="/images/traffic_light_' + colour + '.png"'
                +   ' width="15"'
                +   ' height="45"/> ';
    };
    
    var progression = function(from, to, activity) {
      return cd.divPanel(
          'Look for ' + traffic_light(from) + '&rarr;&nbsp;' + traffic_light(to)
        + 'progressions as evidence of ' + activity + '.'
      );        
    };

    var redFirst = progression('red',   'green', 'starting with a failing test');
    var refactor = progression('green', 'green', 'refactoring');
    var amber    = progression('amber', 'amber', 'overly ambitious steps');

    var dashboard = $(cd.makeTable(redFirst, refactor, amber));
      
    return cd.dialog(dashboard.html(), 450, 'tips');
  };

  return cd;
})(cyberDojo || {}, $);



