
function preRunTests() {
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  $j('#output')
    .attr('class', 'waiting')
    .val("Running tests...");
  
  $j('#run_tests').fadeOut('slow', function() {   
      $j('#spinner').show();
  });
  saveCurrentFile();
}

function postRunTests() { 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"
  
  $j('#spinner').fadeOut('slow', function() {
      $j('#run_tests').show();
  });
  
  $j('#editor').focus();
  // new increment could affect layout
  refreshLineNumbering();  
}

