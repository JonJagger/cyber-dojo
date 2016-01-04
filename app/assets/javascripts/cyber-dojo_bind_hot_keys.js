/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var cancel = function(event) {
    event.stopPropagation();
    event.preventDefault();
  };

  var bindRunTests = function(event) {
    cancel(event);
    $('#test-button').click();
    return false;
  };

  var bindLoadNextFile = function(event) {
    cancel(event);
    cd.loadNextFile();
    return false;
  };

  var bindLoadPreviousFile = function(event) {
    cancel(event);
    cd.loadPreviousFile();
    return false;
  };

  var bindShowOutputFile = function(event) {
    cancel(event);
    cd.toggleOutputFile();
    return false;
  };

  var runTestsHotKey         = function() { return 'Alt+t'; };
  var loadNextFileHotKey     = function() { return 'Alt+j'; };
  var loadPreviousFileHotKey = function() { return 'Alt+k'; };
  var showOutputFileHotKey   = function() { return 'Alt+o'; };

  cd.bindHotKeys = function(node) {
    node.bind('keydown', runTestsHotKey(),         bindRunTests);
    node.bind('keydown', loadNextFileHotKey(),     bindLoadNextFile);
    node.bind('keydown', loadPreviousFileHotKey(), bindLoadPreviousFile);
    node.bind('keydown', showOutputFileHotKey(),   bindShowOutputFile);
  };

  return cd;

})(cyberDojo || {}, $);
