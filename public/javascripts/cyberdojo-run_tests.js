
var cyberDojo = (function($cd, $j) {

  $cd.runTests = function() {
    $j('#run_tests_button').click();
  };

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
    
    $j('#output_line_numbers, #output')
      .removeClass('failed error passed')
      .addClass($j('#outcome').html());
      
    $j('input[id="radio_output"]+label').parent()
      .removeClass('failed error passed')
      .addClass($j('#outcome').html());      
      
    $cd.loadFile('output');
  };

  return $cd;
})(cyberDojo || {}, $j);


