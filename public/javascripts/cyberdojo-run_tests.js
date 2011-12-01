
var cyberDojo = (function($cd) {

  $cd.runTests = function() {
    $j('#run_tests_button').click();
  };

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    if ($cd.currentTabIndex === $cd.EDITOR_TAB_INDEX) {
      $cd.saveFile($cd.currentFilename());
      $j('#editor_tabs').tabs('select', $cd.OUTPUT_TAB_INDEX);
    }
    $j('#output').val('Running tests...');
    $j('#run_tests').hide();
    $j('#spinner').show();
  };

  $cd.postRunTests = function() { 
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :complete => "postRunTests();"
  
    $j('#spinner').hide();
    $j('#run_tests').show();
    $j('#editor_tabs').tabs('select', $cd.OUTPUT_TAB_INDEX);
    $j('#output').focus();
  };

  return $cd;
})(cyberDojo || {});


