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
    var setLine = function() {
      numbers.scrollTop(content.scrollTop());
    };
    content.bind({
      keydown   : setLine,
      scroll    : setLine,
      mousewheel: setLine,
      mousemove : setLine,
      mousedown : setLine,
      mouseup   : setLine
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.lineNumbers = (function() {
    var number, lines = '1';
    for (number = 2; number < 999; number += 1) {
      lines += '\r\n' + number;
    }
    return lines;
  })();

  return cd;
})(cyberDojo || {}, $);
