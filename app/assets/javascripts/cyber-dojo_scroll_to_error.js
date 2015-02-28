/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var blink = function(line) {
    var twoSeconds = 2000;
    // Colors are hard-wired. Saving them
    // and then resetting can fail with
    // rapid repeated Alt+g keystrokes.
    var color      = '#BFBFBF';
    var background = '#7A7A7A';

    line.css('color', background);
    line.css('background', color);
    setTimeout(function() {
      line.css('color', color);
      line.css('background', background);
    }, twoSeconds);
  };

  //- - - - - - - - - - - - - - - - - - - -

  cd.scrollToError = function() {

    return; // work in progress

    var filename = 'cyber-dojo.sh';
    var lineNumber = '1';

    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);

    var line = $('#' + lineNumber, numbers);
    var downFromTop = 150;
    var instantly = 0;

    cd.loadFile(filename);

    // line-numbers is not directly scrollable but animate works!
    numbers.animate({
      // scroll the line-number into view
      scrollTop: '+=' + (line.offset().top - downFromTop) + 'px'
      }, instantly, function() {
        // align the content to the line-number
        content.scrollTop(numbers.scrollTop());
        blink(line);
      });
  };

  return cd;
})(cyberDojo || {}, $);
