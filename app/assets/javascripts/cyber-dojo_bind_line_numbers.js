/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.bindAllLineNumbers = function() {
    $.each(cd.filenames(), function(i, filename) {
      cd.bindLineNumbers(filename);
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbers = function(filename) {
    var numbers = cd.lineNumbersFor(filename);
    cd.bindLineNumbersEvents(filename);
    numbers.attr('readonly', 'true');
    numbers.html(cd.lineNumbers);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.lineNumbersFor = function(filename) {
    return cd.id(filename + '_line_numbers');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbersEvents = function(filename) {
    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);
    cd.bindLineNumbersFromTo(content, numbers);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbersFromTo = function(content, numbers) {
    var synchScroll = function() {
      numbers.scrollTop(content.scrollTop());
    };
    content.bind({
      keydown   : synchScroll,
      scroll    : synchScroll,
      mousewheel: synchScroll,
      mousemove : synchScroll,
      mousedown : synchScroll,
      mouseup   : synchScroll
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.lineNumbers = (function() {
    var number, lines = '';
    for (number = 1; number < 9999; number += 1) {
      lines += '<div id="' + number + '">' + number + '</div>';
    }
    return lines;
  })();

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.scrollToError = function() {
    return; // work in progress
    var filename = 'test_hiker.rb';
    var lineNumber = '41';

    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);
    var line = $('#' + lineNumber, numbers);
    var downFromTop = 150;
    var instantly = 0;

    var blinkLineNumber = function() {
      var oneSecond = 1000;
      // Colors are hard-wired. Saving them
      // and then resetting can fail with
      // rrepeated Alt+g keystrokes.
      var color      = '#BFBFBF';
      var background = '#7A7A7A';

      line.css('color', background);
      line.css('background', color);
      setTimeout(function() {
        line.css('color', color);
        line.css('background', background);
      }, oneSecond);
    };

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
