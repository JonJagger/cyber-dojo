
function currentFilename()
{
  return $j("input[name='filename']:checked").val();
}

function saveFile(filename)
{
  // Important to make sure Editor tab is visible to ensure caretPos() works properly.
  // See http://stackoverflow.com/questions/1516297/how-to-hide-wmd-editor-initially
  $j('#editor_tabs').tabs('select', EDITOR_TAB_INDEX);

  var editor = $j('#editor');
  fileContent(filename).attr('value', editor.val());
  fileCaretPos(filename).attr('value', editor.caretPos());
  fileScrollLeft(filename).attr('value', editor.scrollLeft());
  fileScrollTop(filename).attr('value', editor.scrollTop());
}

function loadFile(filename) 
{
  // Important to make sure Editor tab is visible to ensure caretPos() works properly.
  // See http://stackoverflow.com/questions/1516297/how-to-hide-wmd-editor-initially
  $j('#editor_tabs').tabs('select', EDITOR_TAB_INDEX);
  
  var caretPos = fileCaretPos(filename).attr('value');
  var scrollTop  = fileScrollTop(filename).attr('value');
  var scrollLeft = fileScrollLeft(filename).attr('value');
  var code = fileContent(filename).attr('value');

  var editor = $j('#editor');
  editor.val(code);
  editor.caretPos(caretPos);
  editor.scrollTop(scrollTop);
  editor.scrollLeft(scrollLeft);
  
  selectFileInFileList(filename);
}

function selectFileInFileList(filename) 
{
  // Can't do $j('radio_' + filename) because filename
  // could contain characters that aren't strictly legal
  // characters in a dom node id
  // NB: This fails if the filename contains a double quote
  $j('[id="radio_' + filename + '"]').attr('checked', 'checked');
  $j('#current_filename').attr('value', filename);
  
  var editor = $j('#editor');
  
  if (filename === 'cyberdojo.sh') {
    $j('#file_op_rename').attr('disabled', true);
    $j('#file_op_delete').attr('disabled', true);
  } else {
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
  var filenames = allFilenames();
  sortFilenames(filenames);
  return filenames;
}

function loadNextFile()
{
  var previousFilename = currentFilename();
  var filenames = sortedFilenames();
  var index = $j.inArray(previousFilename, filenames);
  var nextFilename = filenames[(index + 1) % filenames.length];
  saveFile(previousFilename);
  loadFile(nextFilename);  
}


