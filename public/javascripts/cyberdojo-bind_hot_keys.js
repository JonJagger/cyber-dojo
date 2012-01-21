
var cyberDojo = (function($cd, $j) {

  $cd.bindRunTests = function(event) {
    event.stopPropagation();
    event.preventDefault();
    $j('#run_tests_button').closest("form").submit();
    return false;    
  };
  
  $cd.bindLoadNextFile = function(event) {
    event.stopPropagation();
    event.preventDefault();
    $cd.loadNextFile();
    return false;
  };

  $cd.runTestsHotKey = function() {
    return 'Alt+t';
  };
  
  $cd.loadNextFileHotKey = function() {
    return 'Alt+f';
  };
  
  $cd.bindHotKeys = function(node) {
    node.bind('keydown', $cd.runTestsHotKey(), $cd.bindRunTests);
    node.bind('keydown', $cd.loadNextFileHotKey(), $cd.bindLoadNextFile);
  };
  
  $cd.unbindHotKeys = function(node) {
    node.unbind('keydown', $cd.runTestsHotKey());
    node.unbind('keydown', $cd.loadNextFileHotKey());
  };
  
  return $cd;
})(cyberDojo || {}, $j);
