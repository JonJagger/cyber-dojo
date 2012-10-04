/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.dialog_why = function() {

    var oslo =
        'Several years ago I took part in a coding dojo in the Scotsman pub in Oslo.<br/>' +
        'At the end of the dojo I was struck by a few thoughts:<br/>' +
        '<br/>';

    var bullet = "&nbsp;&bull;&nbsp;" 
    var feel = bullet + "It didn't <em>feel</em> like a dojo should feel.";
    
    var improve =
      $cd.divPanel(
        'In a coding dojo you should <em>not</em> be thinking ' +
        'about finishing the task; ' +
        'you should be thinking about <em>improving some aspect of your skill</em>. ' +
        'The practice should be repeated. The repetition frees up mental capacity, ' +
        'helping you break out of ' +
        'a completion mindset and into a practice/improvement mindset.' 
      );

    var delay = bullet + 'Several groups took a <em>long</em> time to get ' +
        'started, installing compilers and whatnot.';

    var browser =
      $cd.divPanel(
        'I wondered what the minimum install could be for a coding dojo. ' +
        'I realized it was <em>nothing</em>. ' +
        'You could write your tests and code in a ' +
        'web browser and run your tests on a server. ' +
        'The more I thought about it the more I liked ' +
        'the idea of participants using something ' +
        'that was so obviously <em>not their normal development environment</em>. ' +
        'I felt this would reinforce the idea that in a coding dojo ' +
        'you should <em>not</em> be doing development!'
      );

    var noCollab = bullet + 'There very little collaboration.';
    
    var social =
      $cd.divPanel(
        'I started to sense some of the <em>social</em> possibilities of a ' +
        'browser-based coding dojo, in particular, the idea of treating all the ' +
        "participants as a single team, with everyone able to see everyone else's code."
    );
      
    var why = $j($cd.makeTable(oslo,feel,improve,delay,browser,noCollab,social));
      
    $cd.dialog(why.html(), 950, 'why?');
  };

  return $cd;
})(cyberDojo || {}, $);



