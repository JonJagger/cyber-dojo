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

  var regexFor = function(s) {
    var filenamePattern = '([a-zA-Z0-9_\.]*)';
    var lineNumberPattern = '([0-9]*)';
    s = s.replace('{F}',filenamePattern);
    s = s.replace('{L}',lineNumberPattern);
    return new RegExp(s, 'g');
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFilenameLineNumberRegexSpec = function(colour) {
    if (colour === 'amber') {
      var rubyMiniTestAmberPattern = '{F}:{L}: syntax error';
      var regex = regexFor(rubyMiniTestAmberPattern);
      return  [regex,1,2];
    }
    if (colour === 'red') {
      var rubyMiniTestRedPattern = '\[{F}:{L}\]:';
      var regex = regexFor(rubyMiniTestRedPattern);
      return [regex,1,2];
    }
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFileLocations = function(string,spec) {
    var regex = spec[0];
    return getAllMatches(string,regex).map(function(match) {
      var filename = match[spec[1]];
      var lineNumber = match[spec[2]];
      return [filename,lineNumber];
    });
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getTopMatch = function(colour) {
    var specs = getFilenameLineNumberRegexSpec(colour);

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
