/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_refactoring = function() {

    var refactor =
      cd.divPanel(''
        + 'Here are some refactoring katas for:'
        + '<br>'
        + 'the <a href="http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html">Yahtzee kata</a> in C#, C++, Java, Python. '
        + '<br>'
        + 'the <a href="http://emilybache.blogspot.co.uk/2013/01/setting-up-new-code-kata-in-cyber-dojo.html">Tennis kata</a> in C#, C++, Java, Python, Ruby. '
      );

    var table = $(cd.makeTable(refactor));
      
    return cd.dialog(table.html(), 650, 'refactoring');
  };

  return cd;
})(cyberDojo || {}, $);



