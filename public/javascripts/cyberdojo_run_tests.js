
function runTests()
{
  $j('#run_tests_button').click();
}

function preRunTests() {
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  saveCurrentFile();
  // Make sure filenames cannot be used to change file selection
  tests_running = true;  
  selectFileInFileList('output');
  $j('#file_op_new').attr('disabled', true);
  $j('#editor')
    .attr('class', 'waiting')
    .val('Running tests...');
    
  $j('#run_tests').hide();
  $j('#spinner').show();
  // prefill output so if connection is lost this
  // is what will be copied into the editor.
  $j('#output').val('CyberDojo client could not connect to server\n(have you lost your internet connection?)');
}

function postRunTests() { 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"

  $j('#spinner').hide();
  $j('#run_tests').show();

  selectFileInFileList('output');
  $j('#editor').val($j('#output').val())
               .scrollTop(0)
               .scrollLeft(0);
  $j('#file_op_new').removeAttr('disabled');
  tests_running = false;
  // new increment could affect layout
  refreshLineNumbering();  
}

