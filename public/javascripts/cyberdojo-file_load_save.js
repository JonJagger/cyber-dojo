
var cyberDojo = (function($cd, $j) {

  $cd.fileDiv = function(filename) {
    return $cd.id(filename + '_div');
  };
  
  $cd.loadFile = function(filename) {
    var caretPos = $cd.fileCaretPos(filename).attr('value');
    var scrollTop  = $cd.fileScrollTop(filename).attr('value');
    var scrollLeft = $cd.fileScrollLeft(filename).attr('value');
    $cd.selectFileInFileList(filename);
    $cd.fileDiv(filename).show();
    var editor = $cd.fileContentFor(filename);
    editor.caretPos(caretPos);
    editor.scrollTop(scrollTop);
    editor.scrollLeft(scrollLeft);
  };

  $cd.saveFile = function(filename) {
    var file = $cd.fileContentFor(filename);
    $cd.fileCaretPos(filename).attr('value', file.caretPos());
    $cd.fileScrollTop(filename).attr('value', file.scrollTop());
    $cd.fileScrollLeft(filename).attr('value', file.scrollLeft());
    $cd.fileDiv(filename).hide();
  };

  $cd.specialFile = function(filename) {
    return filename === 'cyberdojo.sh' || filename === 'output';  
  };
  
  $cd.selectFileInFileList = function(filename) {
    // Can't do $j('radio_' + filename) because filename
    // could contain characters that aren't strictly legal
    // characters in a dom node id
    // NB: This fails if the filename contains a double quote
    
    var selected = $j('[id="radio_' + filename + '"]');
    selected.parent().siblings().each(function() {
      $j(this).attr('current_file', 'false');      
    });
    selected.parent().attr('current_file', 'true');    
    selected.attr('checked', 'checked');
    $j('#current_filename').attr('value', filename);
    
    var file_ops = $j('#file_operation_buttons');
    var renameFile = file_ops.find('#rename');
    var deleteFile = file_ops.find('#delete');
    
    if ($cd.specialFile(filename)) {
      renameFile.attr('disabled', true);
      renameFile.removeAttr('title');
      deleteFile.attr('disabled', true);
      deleteFile.removeAttr('title');
    } else {
      renameFile.removeAttr('disabled');
      renameFile.attr('title', 'Rename the current file');
      deleteFile.removeAttr('disabled');
      deleteFile.attr('title', 'Delete the current file');
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
})(cyberDojo || {}, $j);

