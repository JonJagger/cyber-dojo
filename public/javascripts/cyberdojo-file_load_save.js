
var cyberDojo = (function($cd) {

  $cd.EDITOR_TAB_INDEX = 0;
  $cd.OUTPUT_TAB_INDEX = 1;

  $cd.currentTabIndex = false;

  $cd.loadFile = function(filename) {
    // Important to make sure Editor tab is visible to ensure caretPos() works properly.
    // See http://stackoverflow.com/questions/1516297/how-to-hide-wmd-editor-initially
    $j('#editor_tabs').tabs('select', $cd.EDITOR_TAB_INDEX);
    
    var caretPos = $cd.fileCaretPos(filename).attr('value');
    var scrollTop  = $cd.fileScrollTop(filename).attr('value');
    var scrollLeft = $cd.fileScrollLeft(filename).attr('value');
    var code = $cd.fileContent(filename).attr('value');
  
    var editor = $j('#editor');
    editor.val(code);
    editor.caretPos(caretPos);
    editor.scrollTop(scrollTop);
    editor.scrollLeft(scrollLeft);
    
    $cd.selectFileInFileList(filename);
  };

  $cd.saveFile = function(filename) {
    // Important to make sure Editor tab is visible to ensure caretPos() works properly.
    // See http://stackoverflow.com/questions/1516297/how-to-hide-wmd-editor-initially
    $j('#editor_tabs').tabs('select', $cd.EDITOR_TAB_INDEX);
  
    var editor = $j('#editor');
    $cd.fileContent(filename).attr('value', editor.val());
    $cd.fileCaretPos(filename).attr('value', editor.caretPos());
    $cd.fileScrollTop(filename).attr('value', editor.scrollTop());
    $cd.fileScrollLeft(filename).attr('value', editor.scrollLeft());
  };

  $cd.selectFileInFileList = function(filename) {
    // Can't do $j('radio_' + filename) because filename
    // could contain characters that aren't strictly legal
    // characters in a dom node id
    // NB: This fails if the filename contains a double quote
    $j('[id="radio_' + filename + '"]').attr('checked', 'checked');
    $j('#current_filename').attr('value', filename);
    
    if (filename === 'cyberdojo.sh') {
      $j('#file_op_rename').attr('disabled', true);
      $j('#file_op_delete').attr('disabled', true);
    } else {
      $j('#file_op_rename').removeAttr('disabled');
      $j('#file_op_delete').removeAttr('disabled');
    }
  };

  $cd.currentFilename = function() {
    return $j("input[name='filename']:checked").val();
  };

  $cd.loadNextFile = function() {
    var previousFilename = $cd.currentFilename();
    var filenames = $cd.sortedFilenames();
    var index = $j.inArray(previousFilename, filenames);
    var nextFilename = filenames[(index + 1) % filenames.length];
    $cd.saveFile(previousFilename);
    $cd.loadFile(nextFilename);  
  };
  
  $cd.sortFilenames = function(filenames) {
    filenames.sort(function(lhs, rhs) 
      {
	if (lhs < rhs)
	  return -1;
	else if (lhs > rhs)
	  return 1;
	else
	  return 0; // Should never happen (implies two files with same name)
      });
  };

  $cd.sortedFilenames = function() {
    var filenames = $cd.allFilenames();
    $cd.sortFilenames(filenames);
    return filenames;
  };
  
  $cd.fileContent = function(filename) {
    return $j("[id='file_content_for_" + filename + "']");
  };

  $cd.fileCaretPos = function(filename) {
    return $j("[id='file_caret_pos_for_" + filename + "']");
  };

  $cd.fileScrollTop = function(filename) {
    return $j("[id='file_scroll_top_for_" + filename + "']");
  };

  $cd.fileScrollLeft = function(filename) {
    return $j("[id='file_scroll_left_for_" + filename + "']");
  };

  return $cd;
})(cyberDojo || {});

