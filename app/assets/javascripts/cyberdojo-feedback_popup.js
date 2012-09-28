/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.feedbackPopup = function() {
    
    var appreciate =
      $cd.divPanel(
        " I'd really appreciate it if you could" +
        ' <a href="mailto:jon@jaggersoft.com?subject=cyber-dojo%20feedback">give me feedback</a>.<br/>' +
        ' What did you like? What did you dislike?<br/>' +
        " What worked? What didn't?</br>" +
        '  What features should I add? Remove?'
      );
    
    var tellMe = '' +
      $cd.divPanel(
        ' Please tell me about your use of cyber-dojo and<br/>' +
        " I'll add it to the" +
        ' <a href="http://jonjagger.blogspot.co.uk/2012/09/cyber-dojo-dates.html">cyber-dojo blog page</a>.' 
      );
    
    var grid = $j($cd.makeTable(appreciate, tellMe));
      
    $cd.dialogPopup(grid.html(), 650, 'feedback');
  };

  return $cd;
})(cyberDojo || {}, $);



