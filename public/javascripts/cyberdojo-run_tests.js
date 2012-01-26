
var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    $j('#run_tests').hide();
    $j('#spinner').show();
    $cd.unbindAllLineNumbers(); // to reduce network bandwidth
  };

  $cd.postRunTests = function() { 
    $cd.bindAllLineNumbers();
    $j('#spinner').hide();
    $j('#run_tests').show();
    // when rjs replaces output shortcuts are lost
    // so need to rebind them    
    var output = $cd.fileContentFor('output');
    $cd.unbindHotKeys(output);
    $cd.bindHotKeys(output);        
    $cd.loadFile('output');
  };

  return $cd;
})(cyberDojo || {}, $j);


