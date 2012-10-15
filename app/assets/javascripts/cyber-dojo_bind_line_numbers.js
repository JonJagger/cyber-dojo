/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.lineNumbersFor = function(filename) {
    return cd.id(filename + '_line_numbers');  
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindAllLineNumbers = function() {
    $.each(cd.filenames(), function(i,filename) {
      cd.bindLineNumbers(filename);
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbers = function(filename) {
    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);
    
    numbers.attr('readonly', 'true');
    numbers.val(cd.lineNumbers);
    
    function setLine() {
      numbers.scrollTop(content.scrollTop());   
    }
    
    content.bind({
      scroll:     function(ev) { setLine(); },
      mousewheel: function(ev) { setLine(); },
      keydown:    function(ev) { setLine(); },
      mousedown:  function(ev) { setLine(); },
      mouseup:    function(ev) { setLine(); },
      mousemove:  function(ev) { setLine(); }
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

