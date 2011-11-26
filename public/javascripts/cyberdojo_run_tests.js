
function runTests()
{
  $j('#run_tests_button').click();
}

function preRunTests()
{
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  saveCurrentFile();
  $j('#run_tests').hide();
  $j('#spinner').show();
  // prefill output so if connection is lost this
  // is what will be copied into the editor.
  $j('#output').val(
    'CyberDojo client could not connect to server\n' +
    '(have you lost/switched your network connection?)');
}

function postRunTests()
{ 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"

  $j('#spinner').hide();
  $j('#run_tests').show();
  $j('#editor_tabs').tabs('select', 1);
}

