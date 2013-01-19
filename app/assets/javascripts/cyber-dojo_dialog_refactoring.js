/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_refactoring = function() {

    var refactor =
      cd.divPanel(''
        + 'Here are some <a href="http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html">Yahtzee refactoring katas</a> in Java, C#, C++, Python. '
        + '<br>'
        + 'Here are some <a href="http://emilybache.blogspot.co.uk/2013/01/setting-up-new-code-kata-in-cyber-dojo.html">Tennis refactoring katas</a> in C++, Ruby, Java, Python. '
      );

    var table = $(cd.makeTable(refactor));
      
    return cd.dialog(table.html(), 650, 'refactoring');
  };

  return cd;
})(cyberDojo || {}, $);



