/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_feedback = function() {
    
    var mailUrl = 'mailto:jon@jaggersoft.com?subject=cyber-dojo%20feedback';
    var appreciate =
      cd.divPanel(
          " I'd really appreciate it if you could"
        + ' <a href="' + mailUrl + '">give me feedback</a>.<br/>'
        + ' What did you like? What did you dislike?<br/>'
        + " What worked? What didn't?</br>"
        + '  What features should I add? Remove?'
      );
    
    var blogUrl = 'http://jonjagger.blogspot.co.uk/2012/09/cyber-dojo-dates.html';
    var tellMe = '' +
      cd.divPanel(
          ' Please tell me about your use of cyber-dojo and<br/>'
        + " I'll add it to the"
        + ' <a href="' + blogUrl + '" target="_blank">cyber-dojo blog page</a>.'
      );
    
    var feedback = $(cd.makeTable(appreciate, tellMe));
      
    cd.dialog(feedback.html(), 500, 'feedback');
  };

  return cd;
})(cyberDojo || {}, $);



