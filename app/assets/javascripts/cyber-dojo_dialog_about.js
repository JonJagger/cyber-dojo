/*jsl:option explicit*/

var cyberDojo = (function(cd, $) {

  cd.dialog_about = function() {

    var nonIde =
      cd.divPanel(
          "cyber-dojo is the world's simplest<br/>"
        + '<em>non</em>-development environment!'
      );

    var practice =
      cd.divPanel(
          'In a cyber-dojo you <em>practice</em><br/>'
        + 'by going <em>slower</em><br/>'
        + 'and focusing on <em>improving</em><br/>'
        + 'rather than finishing.' 
      );

    var author =
      cd.divPanel(
          'cyber-dojo was conceived, designed,<br/>'
        + 'and implemented by '
        + '<a href="http://jonjagger.blogspot.com/" target="_blank">Jon Jagger</a>'
      );

    var about = $(cd.makeTable(nonIde, practice, author));
      
    cd.dialog(about.html(), 400, 'about');
  };

  return cd;
})(cyberDojo || {}, $);



