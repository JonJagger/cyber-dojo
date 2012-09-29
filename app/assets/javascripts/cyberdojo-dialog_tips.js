/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_tips = function() {

    var bellOne =    
      $cd.divPanel(
        'Periodically ring a bell. At the bell the current ' +
        '<em>driver</em> moves to a different computer and ' +
        'becomes the <em>navigator</em> (this also ' +
        'helps to dampen the effect of some developers dominating the keyboard.)'
      );

    var bellTwo =
      $cd.divPanel(
        'Periodically ring a bell. At the bell the current ' +
        '<em>driver</em> moves to the computer to their <em>left</em> ' +
        'and becomes the <em>navigator</em>, ' +
        'and the current <em>navigator</em> moves to the computer to their ' +
        '<em>right</em> ' +
        'and becomes the <em>driver</em>. ' +
        'This means <em>both</em> members of the pair will ' +
        'be at new code at every bell!'
      );

    var average =
      $cd.divPanel(
        'Play the ' +
        '<a href="http://jonjagger.blogspot.com/2009/06/average-time-to-green-game.html">' +
        'average-time-to-green-game' +
        '</a>.'
      );

    var atGreen =
      $cd.divPanel(
        'When everyone is at green set a challenge to either<br/> ' +
        ' &nbsp;&nbsp;&bull; find some code you can delete and the tests still all pass!<br/>' +
        ' &nbsp;&nbsp;&bull; find a bug, and write a failing test for it.'
      );

    var recruit =
      $cd.divPanel(
        'Several companies use cyber-dojo as part of their recruitment. ' +
        'Why not see how five prospective hires fare technically and socially ' +
        "by pairing them with five of the team they're hoping to join in a cyber-dojo! " +
        'Do five iterations swapping partners each time.'
      );

    var tips = $j($cd.makeTable(bellOne,bellTwo,average,atGreen,recruit));
  
    $cd.dialog(tips.html(), 900, 'tips');
  };

  return $cd;
})(cyberDojo || {}, $);



