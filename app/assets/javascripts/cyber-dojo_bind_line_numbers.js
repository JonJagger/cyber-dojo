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
    var filename = 'instructions';
    var lineNumber = '45';

    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);
    var line = $('#' + lineNumber, numbers);
    var downFromTop = 150;
    var instantly = 0;

    cd.loadFile(filename);

    // line-numbers is not directly scrollable but animate works!
    numbers.animate({
      scrollTop: '+=' + (line.offset().top - downFromTop) + 'px'
      }, instantly, function() {
        content.scrollTop(numbers.scrollTop());
        line.css('color', 'black');
      });
  };

  return cd;
})(cyberDojo || {}, $);
