
function showServerMessage(message)
{
  if (message != "")
  {
    saveCurrentFile();
    $('play_panel').hide();
    $('server_message_content').innerHTML = message;
    $('server_message_panel').show();
  
    var milliSeconds = 1;
    var oneSecond = 1000 * milliSeconds;
    setTimeout( function() { hideServerMessage(); }, 10 * oneSecond);
  }  
}

function hideServerMessage()
{
  $('server_message_panel').hide();
  $('play_panel').show();  
  loadFile(current_filename); // refresh caretPos in current filename
}

