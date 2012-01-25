
var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    $cd.saveFile($cd.currentFilename());
    
    $j('#run_tests').hide();
    $j('#spinner').show();
    
    // Reduce bandwidth by not sending line-numbers.
    $cd.unbindAllLineNumbers();
  };

  $cd.postRunTests = function() { 
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :complete => "postRunTests();"

    // Restore line-numbers.
    $cd.bindAllLineNumbers();
      
    $j('#spinner').hide();
    $j('#run_tests').show();
    $cd.loadFile('output');
    
    var output = $j('[id="file_content_for_output"]');

    output.focus();
    $cd.unbindHotKeys(output);
    $cd.bindHotKeys(output);    
  };

  return $cd;
})(cyberDojo || {}, $j);


