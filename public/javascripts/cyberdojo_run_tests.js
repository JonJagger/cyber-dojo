
var isControl = false;

document.onkeyup = function(e) 
{
	if (keyCode(e) == 17) 
		isControl = false;
}

document.onkeydown = function(e)
{
	if (keyCode(e) == 17) 
		isControl = true;
	
	if (keyCode(e) == 83 && isControl == true) 
	{
		//run code for CTRL+S -- ie, save!
		alert("There is no Save! Press the play button instead");
		return false;
	}
}

function keyCode(e)
{
	var code;
	if (e.keyCode)
		code = e.keyCode;
	else if (e.which)
		code = e.which;
	return code;
}

function runTests()
{
  $('play_button').click();
}

function preRunTests()
{
  // app/views/kata/view.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before   => "preRunTests();",
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

