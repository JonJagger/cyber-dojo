
function preRunTests() {
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",
  $('run_tests').hide();    
  $('spinner').show();    
  $('output').setAttribute('class', 'waiting');
  $('output').value = "Running tests...";
  saveCurrentFile();
}

function postRunTests() { 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"
  // new increment could affect layout
  
  $('editor').focus();
  $('spinner').hide();
  $('run_tests').show();
  refreshLineNumbering();  
}

