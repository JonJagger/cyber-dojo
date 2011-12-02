
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
    var filenames = $cd.filenames().sort();
    var index = $j.inArray(previousFilename, filenames);
    var nextFilename = filenames[(index + 1) % filenames.length];
    $cd.saveFile(previousFilename);
    $cd.loadFile(nextFilename);  
  };
    
  $cd.fileContent = function(filename) {
    return $cd.fileAspect(filename, 'content');
  };
  
  $cd.fileCaretPos = function(filename) {
    return $cd.fileAspect(filename, 'caret_pos');    
  };

  $cd.fileScrollTop = function(filename) {
    return $cd.fileAspect(filename, 'scroll_top');    
  };

  $cd.fileScrollLeft = function(filename) {
    return $cd.fileAspect(filename, 'scroll_left');    
  };

  $cd.fileAspect = function(filename, aspect) {
    return $j("[id='file_" + aspect + "_for_" + filename + "']");    
  };
  
  return $cd;
})(cyberDojo || {});

