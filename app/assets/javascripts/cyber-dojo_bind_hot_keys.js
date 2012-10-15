/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.bindRunTests = function(event) {
    event.stopPropagation();
    event.preventDefault();
    $('#test').closest("form").submit();
    return false;    
  };
  
  cd.bindLoadNextFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    cd.loadNextFile();
    return false;
  };

  cd.runTestsHotKey = function() {
    return 'Alt+t';
  };
  
  cd.loadNextFileHotKey = function() {
    return 'Alt+f';
  };
  
  cd.bindHotKeys = function(node) {
    node.bind('keydown', cd.runTestsHotKey(), cd.bindRunTests);
    node.bind('keydown', cd.loadNextFileHotKey(), cd.bindLoadNextFile);
  };
  
  return cd;
})(cyberDojo || {}, $);
