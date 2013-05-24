/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_basics = function() {
    
    var indent = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";    
    var setup =
      cd.divPanel(''
        + '10. Click <span id="setup" class="button">setup</span>, '
        + 'choose a <span class="filename">language</span>, '
        + 'choose an exercise, '
        + 'click <span id="ok" class="button">ok</span><br/>'
        + indent + "You'll get an id, e.g.,"
        + "<span class='kata_id_input'>&nbsp;3AF65A&nbsp;</span>"
    );
    var enter =
      cd.divPanel(''
        + '20. At <em>each</em> computer, '
        + 'enter the <span class="kata_id_input">&nbsp;3AF65A&nbsp;</span> id, '
        + 'and click <div id="start_coding" class="button">start</div><br/>'
    );
    var animal =
      cd.divPanel(''
        + '30. Each computer will be assigned an animal (e.g. panda)'
    );
    var limit =
      cd.divPanel(''
        + '40. Code for a set amount of time '
        + 'e.g. 30/45/60 minutes.'
      );      
    var retro =
      cd.divPanel(''
        + '50. When time is up use the '
        + '<span id="review_coding" class="button">review</span> dashboard '
        + 'to review everyones<br>'
        + indent + 'code and choose what aspects to focus '
        + 'on improving in the next iteration.'
      );
    var repeat =
      cd.divPanel(''
        + '60. goto 10<br/>'
        + indent + 'Start again, doing '
        + 'the <em>same</em> exercise, '
        + 'in the <em>same</em> language.'
        );      
    var basics = $(cd.makeTable(setup,enter,animal,limit,retro,repeat));
      
    return cd.dialog(basics.html(), 800, 'basics');
  };

  return cd;
})(cyberDojo || {}, $);



