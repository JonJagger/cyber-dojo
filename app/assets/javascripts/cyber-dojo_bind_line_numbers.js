/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var rawLineNumbers = (function() {
    // This is used to be 9999 lines but profiling revealed this
    // to be a hotspot! Reducing 9999 to 999 shaved about 2
    // seconds off the typical user-perceived reponse time!
    var number, lines = '';
    for (number = 1; number < 999; number += 1) {
      lines += '<div id="' + number + '">' + number + '</div>';
    }
    return lines;
  })();

  var lineNumbersOn = true;

  var setLineNumbers = function(nodes) {
    if (lineNumbersOn) {
      nodes.addClass('opaque');
    } else {
      nodes.removeClass('opaque');
    }
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindAllLineNumbers = function() {
    // called from app/views/kata/*
    $.each(cd.filenames(), function(_, filename) {
      cd.bindLineNumbers(filename);
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbers = function(filename) {
    // called from cd.newFileContent()
    var content = cd.fileContentFor(filename);
    var numbers = cd.id(filename + '_line_numbers');
    cd.bindLineNumbersFromTo(content, numbers);
    numbers.attr('readonly', 'true');
    numbers.html(rawLineNumbers);
    // called after [test] event so have to be careful to
    // clear out all old handlers.
    numbers.unbind('click').bind('click', function() {
      var all = $('.line_numbers');
      lineNumbersOn = !lineNumbersOn;
      setLineNumbers(all);
    });
    setLineNumbers(numbers);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.bindLineNumbersFromTo = function(content, numbers) {
    // called from app/views/review/*
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

  return cd;

})(cyberDojo || {}, $);
