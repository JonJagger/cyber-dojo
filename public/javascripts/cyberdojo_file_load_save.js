

var current_filename = false;

function saveCurrentFile() 
{
  // current_filename is initially null on dom:loaded
  // TODO: could it be loaded directly into the editor by rails at start?
  if (current_filename) 
  {
    fileContent(current_filename).setAttribute('value', $('editor').value);
    fileCaretPos(current_filename).setAttribute('value', getLiveCaretPos());
  }
}

function loadFile(filename) 
{
  var pos = fileCaretPos(filename).getAttribute('value');
  $('editor').value = fileContent(filename).getAttribute('value');
  setLiveCaretPos(pos);
  selectFileInFileList(filename);
}

function selectFileInFileList(filename) 
{
  $('radio_' + filename).checked = true;
  $('current_filename').setAttribute('value', filename);
  current_filename = filename;
}

function fileContent(filename) 
{
  return $('file_content_for_' + filename);
}

function fileCaretPos(filename) 
{
  return $('file_caret_pos_for_' + filename);
}


