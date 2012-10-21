/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_basics = function() {
    
    var setup =
      cd.divPanel(''
        + '10. Click <span id="setup" class="button">setup</span>, '
        + 'choose a <span class="filename">language</span>, '
        + 'choose an exercise, '
        + 'click <span id="ok" class="button">ok</span><br/>'
        + "You'll get an id, e.g.,"
        + "<span id='kata_id_input'>3AF65A28F9</span>"
    );
    var enter =
      cd.divPanel(''
        + '20. At each computer, '
        + ' enter the <span id="kata_id_input">3AF65A28F9</span> id, '
        + 'click <div id="start_coding" class="button">start</div>'
    );
    var limit =
      cd.divPanel(''
        + '30. Code for a set amount of time '
        + 'e.g. 20/40/60 minutes.'
      );
      
    var retro =
      cd.divPanel(''
        + '40. When time is up everyone uses the '
        + '<span id="review_coding" class="button">review</span> dashboard and '
        + 'diff pages to review what they did and chooses what aspects to focus '
        + 'on improving.'
      );

    var repeat =
      cd.divPanel(''
        + '50. goto 10<br/>'
        + 'Start again, doing '
        + 'the <em>same</em> exercise, '
        + 'in the <em>same</em> language.'
        );
      
    var basics = $(cd.makeTable(setup,enter,limit,retro,repeat));
      
    cd.dialog(basics.html(), 700, 'basics');
  };

  return cd;
})(cyberDojo || {}, $);



