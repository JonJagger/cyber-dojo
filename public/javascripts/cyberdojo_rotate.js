
function doRotation()
{
  saveCurrentFile();
  $('play_panel').setAttribute('style', 'display:none');
  $('rotate_panel').setAttribute('style', 'visibility:visible');
  var oneSecond = 1000;
  setTimeout( "endRotation();", 10 * oneSecond);
}

function endRotation()
{
  $('rotate_panel').setAttribute('style', 'display:none');
  $('play_panel').setAttribute('style', 'visibility:visible');
  // refresh caretPos in current filename
  loadFile(current_filename);
}

