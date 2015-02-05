/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var cancel = function(event) {
    event.stopPropagation();
    event.preventDefault();
  };

  cd.bindRunTests = function(event) {
    cancel(event);
    $('#test-button').click();
    return false;
  };

  cd.bindLoadNextFile = function(event) {
    cancel(event);
    cd.loadNextFile();
    return false;
  };

  cd.bindLoadPreviousFile = function(event) {
    cancel(event);
    cd.loadPreviousFile();
    return false;
  };

  cd.bindShowOutputFile = function(event) {
    cancel(event);
    cd.toggleOutputFile();
    return false;
  };

  cd.bindScrollToError = function(event) {
    cancel(event);
    cd.scrollToError();
    return false;
  };

  cd.runTestsHotKey = function() {
    return 'Alt+t';
  };

  cd.loadNextFileHotKey = function() {
    return 'Alt+j';
  };

  cd.loadPreviousFileHotKey = function() {
    return 'Alt+k';
  };

  cd.showOutputFileHotKey = function() {
    return 'Alt+o';
  };

  cd.scrollToErrorHotKey = function() {
    return 'Alt+g';
  };

  cd.bindHotKeys = function(node) {
    node.bind('keydown', cd.runTestsHotKey(),     cd.bindRunTests);
    node.bind('keydown', cd.loadNextFileHotKey(), cd.bindLoadNextFile);
    node.bind('keydown', cd.loadPreviousFileHotKey(), cd.bindLoadPreviousFile);
    node.bind('keydown', cd.showOutputFileHotKey(), cd.bindShowOutputFile);
    node.bind('keydown', cd.scrollToErrorHotKey(), cd.bindScrollToError);
  };

  return cd;
})(cyberDojo || {}, $);
