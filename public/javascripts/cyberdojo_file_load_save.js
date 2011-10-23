
var current_filename = false;
var tests_running = false;

function saveCurrentFile() 
{
  if (tests_running)
    return;
  
  if (current_filename) 
  {
    var editor = $j('#editor');
    fileContent(current_filename).attr('value', editor.val());
    fileCaretPos(current_filename).attr('value', editor.caretPos());
    fileScrollLeft(current_filename).attr('value', editor.scrollLeft());
    fileScrollTop(current_filename).attr('value', editor.scrollTop());
  }
}

function loadFile(filename) 
{
  if (tests_running)
    return;
  
  var caret_pos = fileCaretPos(filename).attr('value');
  var scroll_top  = fileScrollTop(filename).attr('value');
  var scroll_left = fileScrollLeft(filename).attr('value');
  var code = fileContent(filename).attr('value');

  var editor = $j('#editor');
  editor.val(code);
  editor.caretPos(caret_pos);
  editor.scrollTop(scroll_top);
  editor.scrollLeft(scroll_left);
  
  selectFileInFileList(filename);
}

function selectFileInFileList(filename) 
{
  // can't do $j('radio_' + filename) because filename
  // could contain characters that aren't strictly legal
  // characters in a dom node id
  // NB: This fails if the filename contains a double quote
  $j('[id="radio_' + filename + '"]').attr('checked', 'checked');
  $j('#current_filename').attr('value', filename);
  
  current_filename = filename;
  var editor = $j('#editor');

  if (filename === 'output') {
    editor.attr('readonly', 'true');
  }
  else {
    editor.removeAttr('readonly');
  }
  
  if (filename === 'output' || filename === 'cyberdojo.sh')
  {
    $j('#file_op_rename').attr('disabled', true);
    $j('#file_op_delete').attr('disabled', true);
  }
  else
  {
    $j('#file_op_rename').removeAttr('disabled');
    $j('#file_op_delete').removeAttr('disabled');
  }
}

function fileContent(filename) 
{
  return $j("[id='file_content_for_" + filename + "']");
}

function fileCaretPos(filename) 
{
  return $j("[id='file_caret_pos_for_" + filename + "']");
}

function fileScrollLeft(filename)
{
  return $j("[id='file_scroll_left_for_" + filename + "']");
}

function fileScrollTop(filename)
{
  return $j("[id='file_scroll_top_for_" + filename + "']");
}

function sortedFilenames()
{
  filenames = allFilenames();
  sortFilenames(filenames);
  return filenames;
}

function indexOfCurrentFile(filenames)
{
  for(var at = 0; at < filenames.length; at++)
    if (filenames[at] === current_filename)
      var index = at;
  return index;
}

function loadPreviousFile()
{
  var filenames = sortedFilenames();
  var index = indexOfCurrentFile(filenames);       
  var previousIndex = (index === 0) ? filenames.length - 1 : index - 1;
  saveCurrentFile();
  loadFile(filenames[previousIndex]);
}

function loadNextFile()
{
  var filenames = sortedFilenames();
  var index = indexOfCurrentFile(filenames);       
  var nextIndex = (index === filenames.length - 1) ? 0 : index + 1;
  saveCurrentFile();
  loadFile(filenames[nextIndex]);  
}


