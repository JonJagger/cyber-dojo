
var cyberDojo = (function($cd, $j) {

  $cd.runTests = function() {
    $j('#run_tests_button').click();
  };

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    if ($cd.currentTabIndex === $cd.EDITOR_TAB_INDEX) {
      $cd.saveFile($cd.currentFilename());
    }
    $j('#run_tests').hide();
    $j('#spinner').show();
  };

  $cd.postRunTests = function() { 
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :complete => "postRunTests();"
  
    $j('#spinner').hide();
    $j('#run_tests').show();
    $cd.setOutputTabColourFromMostRecentOutcome();    

    $j('#editor_tabs').tabs('select', $cd.OUTPUT_TAB_INDEX);
    $j('#output').focus();
  };
  
  $cd.setOutputTabColourFromMostRecentOutcome = function() {
    $j('.ui-tabs .ui-tabs-nav li[id="tab_output_li"] a, #output_line_numbers, #output')
      .removeClass('failed error passed')
      .addClass($j('#outcome').html());    
  };

  return $cd;
})(cyberDojo || {}, $j);


