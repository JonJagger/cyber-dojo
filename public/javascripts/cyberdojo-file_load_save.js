
var cyberDojo = (function($cd, $j) {

  $cd.fileDiv = function(filename) {
    return $cd.id(filename + '_div');
  };
  
  $cd.loadFile = function(filename) {
    $cd.fileDiv($cd.currentFilename()).hide();
    $cd.selectFileInFileList(filename);
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
    
    var file_ops = $j('#file_operation_buttons');
    var renameFile = file_ops.find('#rename');
    var deleteFile = file_ops.find('#delete');
    
    if ($cd.cantBeRenamedOrDeleted(filename)) {
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
    
    $cd.fileDiv(filename).show();
    $cd.fileContentFor(filename).focus();
    $j('#current_filename').val(filename);
  };

  $cd.cantBeRenamedOrDeleted = function(filename) {
    return filename === 'cyberdojo.sh' || filename === 'output';  
  };
  
  $cd.loadNextFile = function() {
    var filenames = $cd.filenames().sort();
    var index = $j.inArray($cd.currentFilename(), filenames);
    var nextFilename = filenames[(index + 1) % filenames.length];
    $cd.loadFile(nextFilename);  
  };
    
  return $cd;
})(cyberDojo || {}, $j);

