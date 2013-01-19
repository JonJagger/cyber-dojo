/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_recruiting = function() {

    var recruiting =
      cd.divPanel(''
        + 'Why not use cyber-dojo as part of your recruitment process? '
        + 'See how five prospective hires fare technically and socially '
        + "by pairing them with five of the team they're hoping to join in a cyber-dojo! "
        + 'Do five iterations swapping partners each time.'
      );

    var table = $(cd.makeTable(recruiting));
      
    return cd.dialog(table.html(), 550, 'recruiting');
  };

  return cd;
})(cyberDojo || {}, $);



