/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_basics = function() {

    var team =
      $cd.divPanel(
        'cyber-dojo is for <em>practising</em> as a <em>team</em>, ' +
        'with two or more people per computer.'
      );

    var practice =
      $cd.divPanel(
        'Practising deliberately means repeating the <em>same</em> ' +
        'exercise in the <em>same</em> language, <em>several</em> times. ' +
        'Each repetition is limited to fixed period of time ' +
        '(eg 20/40/60 mins). ' +
        'The repetition might seem strange at first but remember, you ' +
        'are not shipping the code, you are practising!'
      );
      
    var retro =
      $cd.divPanel(
        'At the end of an iteration use the dashboard and ' +
        'diff pages to replay the steps. ' +
        'Everyone writes down some things ' +
        'they did well and some things they could improve. ' +
        "The navigator's job is to focus the next iteration on " +
        '<em>improvement</em> and <em>not</em> on finishing the exercise. ' +
        'Remember, you are not shipping the code, you are practising!'
      );
      
    var basics = $j($cd.makeTable(team,practice,retro));
      
    $cd.dialog(basics.html(), 700, 'basics');
  };

  return $cd;
})(cyberDojo || {}, $);



