/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.dialog_why = function() {

    var em = function(text) {
      return '<em>' + text + '</em>';  
    };

    var oslo = ''
      + 'Several years ago I took part in a coding dojo in '
      + 'the Scotsman pub in Oslo...<br/>'
      + '<br/>';

    var startDelay = ''
      + 'It took a ' + em('long') + ' time to start, '
      + 'installing compilers and whatnot.';

    var browser =
       cd.divPanel(''
        + 'I wondered what the minimum setup could be for a coding dojo. '
        + 'I realized it was ' + em('nothing') + '. '
        + 'You could write your tests and code in a '
        + 'web browser and run your tests on a server. '
        + 'The more I thought about this, the more I liked '
        + 'the idea of participants using something '
        + 'that was so obviously '
        + em('not their normal development environment') + '.'
      );

    var feel = "It didn't " + em('feel') + " like a dojo should feel.";
    
    var improve =
       cd.divPanel(''
        +'In a coding dojo you should ' + em('not') + ' be thinking '
        + 'about finishing the task; '
        + 'you should be thinking about ' + em('improving some aspect of your skill') + '. '
        + 'The practice should be repeated. Repetition frees up mental capacity, '
        + 'helping you break out of a completion mindset '
        + 'and into an improvement mindset.' 
      );

    var endDelay = ''
      + 'It took a ' + em('long') + ' time to '
      + 'finish, each group struggling to connect to a projector.';
      
    var projector =
      cd.divPanel(''
        + 'In a browser-based dojo, everyone could see '
        + "everyone else's code at all times. "
        + 'Only one computer would need '
        + 'to be connected to a projector.'
    );
      
    var noCollab = 'There was very little collaboration.';
    
    var social =
      cd.divPanel(''
        + 'I started to sense some of the ' + em('social') + ' possibilities of a '
        + 'browser-based coding dojo - in particular, the idea of treating all the '
        + 'participants as a single team.'
    );
      
    var why = $(cd.makeTable(oslo,
                   startDelay,browser,
                   feel,improve,
                   endDelay,projector,
                   noCollab,social));
      
    cd.dialog(why.html(), 850, 'why');
  };

  return cd;
})(cyberDojo || {}, $);



