
function runTests() 
{	
  $('play_button').click();
}

function preRunTests()
{
  // app/views/kata/view.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before   => "preRunTests();",
  $('output').setAttribute('class', 'waiting');
	$('output').value = "Running tests...";
  saveCurrentFile();
  $('play_button').setAttribute('style', 'display:none');
  $('run_tests_spinner').setAttribute('style', 'visibility:visible');
}

function postRunTests()
{
  // app/views/kata/view.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"
  $('run_tests_spinner').setAttribute('style', 'display:none');
  $('play_button').setAttribute('style', 'visibility:visible');
  // new increment could affect layout
  refreshLineNumbering();
  $('editor').focus();
}

