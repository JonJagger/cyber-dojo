
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
    var node = $j('[id="radio_' + filename + '"]');
    var previousFilename = $cd.currentFilename();
    var previous = $j('[id="radio_' + previousFilename + '"]');
    $cd.radioEntrySwitch(previous, node);
    
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

  $cd.radioEntrySwitch = function(previous, current) {
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // This is used by the run-tests-page filename radio-list
    // and also the create-page languages/exercises radio-lists
    // See the comment for makeFileListEntry() in
    // cyberdojo-file_new_rename_delete.js
    // I colour the radio entry in jQuery rather than in
    // explicit CSS to try and give better ui appearance in
    // older browsers.
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    $cd.deselectRadioEntry(previous.parent());
    $cd.selectRadioEntry(current);
  };
  
  $cd.deselectRadioEntry = function(node) {  
    node.css('background-color', '#B2EFEF');
    node.css('color', '#777');
  };

  $cd.selectRadioEntry = function(node) {
    node.parent().css('background-color', 'Cornsilk');
    node.parent().css('color', 'DarkGreen');
    node.attr('checked', 'checked');        
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

