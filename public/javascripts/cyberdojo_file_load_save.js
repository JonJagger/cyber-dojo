
var current_filename = false;

function saveCurrentFile() 
{
  if (current_filename) 
  {
    fileContent(current_filename).setAttribute('value', $('editor').value);
    fileCaretPos(current_filename).setAttribute('value', getLiveCaretPos());
    fileScrollLeft(current_filename).setAttribute('value', $j('#editor').scrollLeft());
    fileScrollTop(current_filename).setAttribute('value', $j('#editor').scrollTop());
  }
}

function loadFile(filename) 
{
  var caret_pos = fileCaretPos(filename).getAttribute('value');
  var scroll_top = fileScrollTop(filename).getAttribute('value');
  var scroll_left = fileScrollLeft(filename).getAttribute('value');
  $('editor').value = fileContent(filename).getAttribute('value');
  setLiveCaretPos(caret_pos);
  $j('#editor').scrollTop(scroll_top);
  $j('#editor').scrollLeft(scroll_left);
  
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

function fileScrollLeft(filename)
{
  return $('file_scroll_left_for_' + filename);
}

function fileScrollTop(filename)
{
  return $('file_scroll_top_for_' + filename);
}


