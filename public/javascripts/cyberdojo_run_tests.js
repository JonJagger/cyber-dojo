
function preRunTests() {
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  saveCurrentFile();
  $j('#editor')
    .attr('class', 'waiting')
    .val("Running tests...");
  
  $j('#run_tests').fadeOut('slow', function() {   
      $j('#spinner').show();
  });
}

function postRunTests() { 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"
  
  var editor = $j('#editor');
  editor.val($j('#output').val());
  editor.focus();
  editor.caretPos(0);
    
  selectFileInFileList('output');
  
  // new increment could affect layout
  refreshLineNumbering();

  $j('#spinner').fadeOut('slow', function() {
      $j('#run_tests').show();
  });
}

