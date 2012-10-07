/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_tips = function() {

    var bell =    
      $cd.divPanel(
          'Periodically ring a bell. At the bell the current '
        + '<em>driver</em> moves to a different computer and '
        + 'becomes the <em>navigator</em> (this also '
        + 'helps to dampen the effect of some developers dominating the keyboard.)'
      );

    var average =
      $cd.divPanel(
          'Play the '
        + '<a href="http://jonjagger.blogspot.com/2009/06/average-time-to-green-game.html" '
        + ' target="_blank">'
        + 'average-time-to-green-game'
        + '</a>.'
      );

    var bullet = ' &nbsp;&nbsp;&bull; ';
    var atGreen =
      $cd.divPanel(
          'When everyone is at green set a challenge to either<br/> '
        + bullet + 'find some code you can delete and the tests still all pass!<br/>'
        + bullet + 'find a bug, and write a failing test for it.'
      );

    var refactor =
      $cd.divPanel(
          'Do a '
        + '<a href="http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html" '
        + ' target="_blank">'
        + 'refactoring dojo'
        + '</a>.'
      );

    var recruit =
      $cd.divPanel(
          'Use cyber-dojo as part of your recruitment. '
        + 'See how five prospective hires fare technically and socially '
        + "by pairing them with five of the team they're hoping to join in a cyber-dojo! "
        + 'Do five iterations swapping partners each time.'
      );

    var tips = $j($cd.makeTable(bell,average,atGreen,refactor,recruit));
  
    $cd.dialog(tips.html(), 600, 'tips');
  };

  return $cd;
})(cyberDojo || {}, $);



