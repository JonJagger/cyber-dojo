/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_donations = function() {

    var companies =
      cd.divPanel(
          "Schlumberger Beijing Geoscience Center have found cyber-dojo an "
        + "invaluable tool for training and development of our software community "
        + "and believe the project has a bright future. Thank for you "
        + "contribution to our training efforts. We are delighted to "
        + "sponsor the cyber-dojo project by contributing $1000."
      );

    var individuals =
      cd.divPanel(
          "Olve Maudal, Mike Long, Mathieu Baron, "
        + "Steve Coates, Johannes van Tonder, Santeri Vesalainen, "
        + "Alexander Ottesen, Lars Storjord, Anders Schau Knatten, "
        + "Mike Sutton, James Grenning, Allan Kelly, Videla Lucas."
      );

    var thankYou =
        "<span id='thank_you'>thank you</span>";
        
    var donations = $(cd.makeTable(
        "companies", companies, "individuals", individuals, thankYou));
      
    cd.dialog(donations.html(), 750, 'donations');
  };

  return cd;
})(cyberDojo || {}, $);



