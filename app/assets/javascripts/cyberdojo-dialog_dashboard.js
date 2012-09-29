/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_dashboard = function() {

    var redFirst =
      $cd.divPanel(
        'Look for ' +
        '<img src="/images/traffic-light-red.png" width="20" height="60"/> ' +
        '&rarr;' +
        '<img src="/images/traffic-light-green.png" width="20" height="60"/> ' +
        'progressions as evidence of starting with a failing test.'
      );

    var refactor =
      $cd.divPanel(
        'Look for ' +
        '<img src="/images/traffic-light-green.png" width="20" height="60"/> ' +
        '&rarr;' +
        '<img src="/images/traffic-light-green.png" width="20" height="60"/> ' +
        'progressions as evidence of refactoring.'
      );

    var amber =
      $cd.divPanel(
        'Look for ' +
        '<img src="/images/traffic-light-amber.png" width="20" height="60"/> ' +
        '&rarr;' +
        '<img src="/images/traffic-light-amber.png" width="20" height="60"/> ' +
        'progressions as evidence of overly ambitious steps.'
      );

    var dashboard = $j($cd.makeTable(redFirst,refactor,amber));
      
    $cd.dialog(dashboard.html(), 450, 'dasboard');
  };

  return $cd;
})(cyberDojo || {}, $);



