/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.feedbackPopup = function() {
    
    var appreciate = 
      '<div class="panel">' +
      " I'd really appreciate it if you could" +
      ' <a href="mailto:jon@jaggersoft.com?subject=cyber-dojo%20feedback">give me feedback</a>.<br/>' +
      ' What did you like? What did you dislike?<br/>' +
      " What worked? What didn't?</br>" +
      '  What features should I add? Remove?' +
      '</div>';
    
    var tellMe = '' +
      '<div class="panel">' +
      ' Please tell me about your use of cyber-dojo and<br/>' +
      " I'll add it to the" +
      ' <a href="http://jonjagger.blogspot.co.uk/2012/09/cyber-dojo-dates.html">cyber-dojo blog page</a>.' +
      '</div>';
    
    var grid = $j($cd.makeTable(appreciate, tellMe));
      
    var div = $j('<div>')
      .html('<div style="font-size: 1.2em;">' + grid.html() + '</div>')    
      .dialog({
        autoOpen: false,
        width: 650,
        title: '<h1>feedback</h1>',
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    div.dialog('open');                
  };

  return $cd;
})(cyberDojo || {}, $);



