
function doRotation()
{
  saveCurrentFile();
  $('play_panel').hide();
  $('rotate_panel').show();
  var oneSecond = 1000;
  setTimeout( "endRotation();", 10 * oneSecond);
}

function endRotation()
{
  $('rotate_panel').hide();
  $('play_panel').show();
  // refresh caretPos in current filename
  loadFile(current_filename);
}

