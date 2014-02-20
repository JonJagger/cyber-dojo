/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.testForm = function() {
    return $('#test_button').closest("form");    
  };
  
  cd.bindRunTests = function(event) {
    event.stopPropagation();
    event.preventDefault();
    cd.testForm().submit();
    return false;    
  };
  
  cd.bindLoadNextFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    cd.loadNextFile();
    return false;
  };

  cd.bindLoadPreviousFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    cd.loadPreviousFile();
    return false;
  };

  cd.bindShowOutputFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    cd.loadFile('output');
    return false;
  };

  cd.runTestsHotKey = function() {
    return 'Alt+t';
  };
  
  cd.loadNextFileHotKey = function() {
    return 'Alt+f';
  };
  
  cd.loadPreviousFileHotKey = function() {
    return 'Alt+b';
  };

  cd.showOutputFileHotKey = function() {
    return 'Alt+o';
  };

  cd.bindHotKeys = function(node) {
    node.bind('keydown', cd.runTestsHotKey(),     cd.bindRunTests);
    node.bind('keydown', cd.loadNextFileHotKey(), cd.bindLoadNextFile);
    node.bind('keydown', cd.loadPreviousFileHotKey(), cd.bindLoadPreviousFile);
    node.bind('keydown', cd.showOutputFileHotKey(), cd.bindShowOutputFile);
  };
  
  return cd;
})(cyberDojo || {}, $);
