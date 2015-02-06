/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var getMatches = function(string, regex) {
      var matches = [];
      var match;
      while (match = regex.exec(string)) {
        matches.push(match);
      }
      return matches;
    };

  var getFileLocations = function(string, specs) {
      var result = [];
      for (var i = 0; i < specs.length; i++) {
        var spec = specs[i];
        var regex = spec[0];
        var slots = spec[1];
        var filenameSlot = slots[0];
        var lineNumberSlot = slots[1];
        var matches = getMatches(string,regex).map(function(array) {
            return [array[filenameSlot],array[lineNumberSlot]];
        });
        result = result.concat(matches);
      }
      return result;
    };

  cd.scrollToError = function() {

    return; // work in progress

    // Hard-coded Ruby MiniTest
    var amberRegEx = /([a-zA-Z0-9_\.]*):([0-9]*): syntax error/g;
    var amberSlots = [1,2];
    var amberSpec = [amberRegEx,amberSlots];

    var redRegEx = /\[([a-zA-Z0-9_\.]*):([0-9]*)\]:/g;
    var redSlots = [1,2];
    var redSpec = [redRegEx,redSlots];

    var specs = [amberSpec,redSpec];
    var output = cd.fileContentFor('output').val();
    var matches = getFileLocations(output, specs);

    //TODO: use first filename that names a visible file
    var match = matches[0];


    var filename = match[0];
    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);
    var lineNumber = match[1];

    var line = $('#' + lineNumber, numbers);

    var blinkLineNumber = function() {
      var oneSecond = 1000;
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
      }, oneSecond);
    };

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
        blinkLineNumber();
      });
  };

  return cd;
})(cyberDojo || {}, $);
