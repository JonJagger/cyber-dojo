
var cyberDojo = (function($cd, $j) {

  $cd.bindRunTests = function(event) {
    event.stopPropagation();
    event.preventDefault();
    $cd.runTests();
    return false;    
  };
  
  $cd.bindLoadNextFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    $cd.loadNextFile();
    return false;
  };
  
  $cd.bindHotKeys = function(event) {
    var editor = $j('#editor');
    var output = $j('#output');
    
    var runTestsHotKey = 'Alt+r';
    var loadNextFileHotKey = 'Alt+f';
    
    editor.bind('keydown', runTestsHotKey, $cd.bindRunTests);
    output.bind('keydown', runTestsHotKey, $cd.bindRunTests);
    editor.bind('keydown', loadNextFileHotKey, $cd.bindLoadNextFile);
    output.bind('keydown', loadNextFileHotKey, $cd.bindLoadNextFile);    
  };
  
  return $cd;
})(cyberDojo || {}, $j);
