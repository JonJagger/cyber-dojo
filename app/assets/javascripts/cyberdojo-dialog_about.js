/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_about = function() {

    var nonIde =
      $cd.divPanel(
        "cyber-dojo is the world's simplest<br/>" +
        '<em>non</em>-development environment!'
      );

    var practice =
      $cd.divPanel(
        'In cyber-dojo your aim is to <em>practice</em><br/>' +
        'by going <em>slower</em><br/>' +
        'and focusing on <em>improving</em><br/>' +
        'rather than finishing.' 
      );

    var author =
      $cd.divPanel(
        'cyber-dojo was conceived, designed,<br/>' +
        'and implemented by ' +
        '<a href="http://jonjagger.blogspot.com/">Jon Jagger</a>'
      );

    var about = $j($cd.makeTable(nonIde, practice, author));
      
    $cd.dialog(about.html(), 450, 'about');
  };

  return $cd;
})(cyberDojo || {}, $);



