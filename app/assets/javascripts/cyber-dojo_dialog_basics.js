/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_basics = function() {
    
    var limit =
      cd.divPanel(''
        + 'Code for a set amount of time '
        + 'e.g. 20/40/60 minutes.'
      );
      
    var retro =
      cd.divPanel(''
        + 'When time is up use the dashboard and '
        + 'diff pages to review what you did. '
        + 'Write down some things '
        + 'you did well and some things you could improve. '
      );

    var repeat =
      cd.divPanel(''
        + 'Start again, doing '
        + 'the <em>same</em> exercise, '
        + 'and the <em>same</em> language.'
        );
      
    var basics = $(cd.makeTable(limit,retro,repeat));
      
    cd.dialog(basics.html(), 550, 'basics');
  };

  return cd;
})(cyberDojo || {}, $);



