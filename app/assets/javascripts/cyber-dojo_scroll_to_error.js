/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var getAllMatches = function(string,regex) {
    var matches = [];
    var match;
    while (match = regex.exec(string)) {
      matches.push(match);
    }
    return matches;
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFilenameLineNumberRegexSpecs = function(colour) {
    // Hard-coded for Ruby MiniTest
    if (colour === 'amber') {
      var regex = /([a-zA-Z0-9_\.]*):([0-9]*): syntax error/g;
      var slots = [1,2];
      return  [[regex,slots]];
    }
    if (colour === 'red') {
      var regex = /\[([a-zA-Z0-9_\.]*):([0-9]*)\]:/g;
      var slots = [1,2];
      return [[regex,slots]];
    }
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFileLocations = function(string,specs) {
    var result = [];
    for (var i = 0; i < specs.length; i++) {
      var spec = specs[i];
      var regex = spec[0];
      var matches =
        getAllMatches(string,regex).map(function(array) {
          var slots = spec[1];
          var filenameSlot = slots[0];
          var lineNumberSlot = slots[1];
          return [array[filenameSlot],array[lineNumberSlot]];
        });
      result = result.concat(matches);
    }
    return result;
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getTopMatch = function(colour) {
    var specs = getFilenameLineNumberRegexSpecs(colour);

    var output = cd.fileContentFor('output').val();
    var matches = getFileLocations(output, specs);
    
    //TODO: use first filename that names a visible file
    return matches[0];
  };

  //- - - - - - - - - - - - - - - - - - - -

  var blink = function(line) {
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

  //- - - - - - - - - - - - - - - - - - - -

  cd.scrollToError = function() {

    //return; // work in progress

    var colour = cd.currentTrafficLightColour();
    if (colour != 'amber' && colour != 'red') {
        return;
    }
    var topMatch = getTopMatch(colour);

    var filename = topMatch[0];
    var lineNumber = topMatch[1];
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
