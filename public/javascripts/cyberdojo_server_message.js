
function seconds(n)
{
    var milliSeconds = 1000;
    return n * milliSeconds;
}

function showServerMessage(message)
{
  if (message !== "")
  {
    saveCurrentFile();
    $('play_panel').hide();
    $('server_message_content').innerHTML = message;
    $('server_message_panel').show();
  
    setTimeout( function() { hideServerMessage(); }, seconds(10));
  }  
}

function hideServerMessage()
{
  $('server_message_panel').hide();
  $('play_panel').show();  
  loadFile(current_filename); // refresh caretPos in current filename
}

