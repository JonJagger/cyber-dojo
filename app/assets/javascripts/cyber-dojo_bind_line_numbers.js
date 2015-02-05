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
    //cd.bindLineNumbersFromTo(numbers, content);
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
    var numbers = cd.lineNumbersFor('instructions');
    var line = $('#45', numbers);
    var downFromTop = 150;
    var halfSecond = 500;
    cd.loadFile('instructions');

    numbers.animate({
      scrollTop: line.offset().top - numbers.offset().top - downFromTop
      }, halfSecond);

    var content = cd.fileContentFor(filename);
    content.focus();

  };

  return cd;
})(cyberDojo || {}, $);
