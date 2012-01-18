
var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    // There is a race condition somewhere.
    //
    // I'm starting to think that the way to solve this is to simply give EVERY
    // file its own textarea in its own div. Then no movement of content is
    // required at all. Instead switching from one file to another hides all
    // the editor divs and shows the one selected. YES.
    // Googling seems to suggest that the contents of a textarea are submitted
    // when inside a form. So I think this is the way to go.
    // It's just possible that this will mean the cursorPos and scrollPos
    // values will not need to be stored...Could b a major simplification.
    
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
    $cd.loadFile('output');
    $j('#output').focus();
  };

  return $cd;
})(cyberDojo || {}, $j);


