/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_tips = function() {

    var team =
      cd.divPanel(''
        + 'cyber-dojo is designed to encourage <em>group practice</em> '
        + 'and works well with more than one person at each '
        + 'computer, periodically moving the current keyboard '
        + "'drivers' to different computers as non-drivers."
      );

    var average =
      cd.divPanel(''
        + 'Play the '
        + '<a href="http://jonjagger.blogspot.com/2009/06/average-time-to-green-game.html" '
        + ' target="_blank">'
        + 'average-time-to-green-game'
        + '</a>.'
      );

    var bullet = ' &nbsp;&nbsp;&bull; ';
    var atGreen =
      cd.divPanel(''
        + 'When everyone is at green set a challenge to either<br/> '
        + bullet + 'find some code you can delete and the tests still all pass!<br/>'
        + bullet + 'find a bug, and write a failing test for it.'
      );

    var refactor =
      cd.divPanel(''
        + 'Do a '
        + '<a href="http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html" '
        + ' target="_blank">'
        + 'refactoring dojo'
        + '</a>.'
      );

    var recruit =
      cd.divPanel(''
        + 'Use cyber-dojo as part of your recruitment. '
        + 'See how five prospective hires fare technically and socially '
        + "by pairing them with five of the team they're hoping to join in a cyber-dojo! "
        + 'Do five iterations swapping partners each time.'
      );

    var tips = $(cd.makeTable(team, average, atGreen, refactor, recruit));
  
    cd.dialog(tips.html(), 600, 'tips');
  };

  return cd;
})(cyberDojo || {}, $);



