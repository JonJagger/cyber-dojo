
var cyberDojo = (function($cd, $j) {

  $cd.loadFile = function(filename) {
    var caretPos = $cd.fileCaretPos(filename).attr('value');
    var scrollTop  = $cd.fileScrollTop(filename).attr('value');
    var scrollLeft = $cd.fileScrollLeft(filename).attr('value');
    var code = $cd.fileContent(filename).attr('value');
    
    $cd.selectFileInFileList(filename);
    
    if (filename === 'output') {
      $j('#editor_div').hide();
      $j('#output_div').show();
      var output = $j('#output');
      output.caretPos(caretPos);
      output.scrollTop(scrollTop);
      output.scrollLeft(scrollLeft);
    } else {
      $j('#output_div').hide();      
      $j('#editor_div').show();
      var editor = $j('#editor');
      editor.val(code);
      editor.caretPos(caretPos);
      editor.scrollTop(scrollTop);
      editor.scrollLeft(scrollLeft);
    }     
  };

  $cd.saveFile = function(filename) {
    if (filename !== 'output') {
      var editor = $j('#editor');
      $cd.fileContent(filename).attr('value', editor.val());
      $cd.fileCaretPos(filename).attr('value', editor.caretPos());
      $cd.fileScrollTop(filename).attr('value', editor.scrollTop());
      $cd.fileScrollLeft(filename).attr('value', editor.scrollLeft());
    }
  };

  $cd.specialFile = function(filename) {
    return filename === 'cyberdojo.sh' || filename === 'output';  
  };
  
  $cd.selectFileInFileList = function(filename) {
    // Can't do $j('radio_' + filename) because filename
    // could contain characters that aren't strictly legal
    // characters in a dom node id
    // NB: This fails if the filename contains a double quote
    $j('[id="radio_' + filename + '"]').attr('checked', 'checked');
    $j('#current_filename').attr('value', filename);
    
    var file_op_rename = $j('#file_op_rename');
    var file_op_delete = $j('#file_op_delete');
    
    if ($cd.specialFile(filename)) {
      file_op_rename.attr('disabled', true);
      file_op_delete.attr('disabled', true);
    } else {
      file_op_rename.removeAttr('disabled');
      file_op_delete.removeAttr('disabled');
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

