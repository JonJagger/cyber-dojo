
var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    $cd.saveFile($cd.currentFilename());
    $j('#run_tests').hide();
    $j('#spinner').show();
  };

  $cd.postRunTests = function() { 
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :complete => "postRunTests();"
  
    $j('#spinner').hide();
    $j('#run_tests').show();
    $cd.setOutputColourFromOutcome();
    $cd.loadFile('output');
    $j('#output').focus();
  };

  $cd.setOutputColourFromOutcome = function() {
    $j('#output')
      .removeClass('failed error passed')
      .addClass($j('#outcome').html());    
  };

  return $cd;
})(cyberDojo || {}, $j);


