
function runTests()
{
  $j('#run_tests_button').click();
}

function preRunTests()
{
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  if (currentTabIndex === EDITOR_TAB_INDEX) {
    saveFile(currentFilename());
    $j('#editor_tabs').tabs('select', OUTPUT_TAB_INDEX);
  }
  $j('#output').val('Running tests...');
  $j('#run_tests').hide();
  $j('#spinner').show();
}

function postRunTests()
{ 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"

  $j('#spinner').hide();
  $j('#run_tests').show();
  $j('#editor_tabs').tabs('select', OUTPUT_TAB_INDEX);
  $j('#output').focus();
}

