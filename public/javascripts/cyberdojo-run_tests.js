
var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :before => "preRunTests();",
  
    // There is a race condition error somewhere. The contents of one file
    // are copied into another file. This is something to do with the
    // saveFile() loadFile() interaction. 
    //
    // I'm starting to think that the way to solve this is to simply give EVERY
    // file its own textarea in its own div. Then no movement of content is
    // required at all. Instead switching from one file to another hides all
    // the editor divs and shows the one selected. YES.
    // Googling suggests that the contents of a textarea are submitted
    // when inside a form. The cursorPos and scrollPos values will still
    // need to be stored, so the positions can be restored when a player
    // resumes coding.
    
    $cd.saveFile($cd.currentFilename());
    
    $j('#run_tests').hide();
    $j('#spinner').show();
    
    // Reduce bandwidth by not sending line-numbers.
    $cd.unbindLineNumbers('editor');
    $cd.unbindLineNumbers('output');
  };

  $cd.postRunTests = function() { 
    // app/views/kata/edit.html.erb
    // form_remote_tag :url => {...}, 
    //                 :complete => "postRunTests();"

    // Restore line-numbers.
    $cd.bindLineNumbers('editor');
    $cd.bindLineNumbers('output');
      
    $j('#spinner').hide();
    $j('#run_tests').show();
    $cd.loadFile('output');
    $j('#output').focus();
  };

  return $cd;
})(cyberDojo || {}, $j);


