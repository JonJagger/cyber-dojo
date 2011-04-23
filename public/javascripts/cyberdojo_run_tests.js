
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
  $('play_button').hide();
  $('run_tests_spinner').show();
}

function postRunTests()
{
  // app/views/kata/view.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"
  $('play_button').show();
  // new increment could affect layout
  refreshLineNumbering();
  $('editor').focus();
  $('run_tests_spinner').hide();
}

