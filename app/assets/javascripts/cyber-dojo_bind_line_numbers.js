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
    numbers.val(cd.lineNumbers);
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
    var number, lines = '1';
    for (number = 2; number < 9999; number += 1) {
      lines += '\r\n' + number;
    }
    return lines;
  })();

  return cd;
})(cyberDojo || {}, $);
