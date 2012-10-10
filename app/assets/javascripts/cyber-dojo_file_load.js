/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.loadFile = function(filename) {
    // I want to
    //    1. restore scrollTop and scrollLeft positions
    //    2. restore focus (also restores cursor position)
    // Restoring the focus loses the scrollTop/Left
    // positions so I have to save them in the dom so
    // I can set the back _after_ the call to focus()
    // The call to focus() allows you to carry on
    // typing at the point the cursor left off.
    $cd.saveScrollPosition($cd.currentFilename());
    $cd.fileDiv($cd.currentFilename()).hide();
    $cd.selectFileInFileList(filename);    
    $cd.fileDiv(filename).show();
    $cd.fileContentFor(filename).focus();
    $cd.restoreScrollPosition(filename);
    $j('#current_filename').val(filename);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.saveScrollPosition = function(filename) {
    var fc = $cd.fileContentFor(filename);
    var top = fc.scrollTop();
    var left = fc.scrollLeft();
    var div = $cd.fileDiv(filename);
    div.attr('scrollTop', top);
    div.attr('scrollLeft', left);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.restoreScrollPosition = function(filename) {
    // Restore the saved scrollTop/Left positions.
    // Note that doing the seemingly equivalent
    //   fc.scrollTop(top);
    //   fc.scrollLeft(left);
    // here does _not_ work. I use animate instead with a
    // very fast duration==1
    var div = $cd.fileDiv(filename);
    var top = div.attr('scrollTop') || 0;
    var left = div.attr('scrollLeft') || 0;
    var fc = $cd.fileContentFor(filename);    
    fc.animate({scrollTop: top, scrollLeft: left}, 1);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.setRenameAndDeleteButtons = function(filename) {
    var file_ops = $j('#file_operation_buttons');
    var renameFile = file_ops.find('#rename');
    var deleteFile = file_ops.find('#delete');
    var turnOff = function(node) {
      node.attr('disabled', true);
      node.removeAttr('title');      
    };
    var turnOn = function(node, title) {
      node.removeAttr('disabled');
      node.attr('title', title);      
    };

    if ($cd.cantBeRenamedOrDeleted(filename)) {
      turnOff(renameFile);
      turnOff(deleteFile);
    } else {
      turnOn(renameFile, 'Rename the current file');
      turnOn(deleteFile, 'Delete the current file');
    }    
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.cantBeRenamedOrDeleted = function(filename) {
    // I have changed the shell filename in the exercises/ folders from
    // cyberdojo.sh (no hyphen) to cyber-dojo.sh (with a hyphen) to match
    // the cyber-dojo.com domain name. However, I still need to support old
    // sessions, particularly the ability to fork from a new session from an
    // old diff-view, e.g. the refactoring setups in
    // http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html
    // See also app/assets/javascripts/cyberdojo-files.js    
    // See also app/models/sandbox.rb
    var oldName = 'cyberdojo.sh';
    var newName = 'cyber-dojo.sh';
    var filenames = [ oldName, newName, 'output' ];
    return $cd.inArray(filename, filenames);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.selectFileInFileList = function(filename) {    
    // Can't do $j('radio_' + filename) because filename
    // could contain characters that aren't strictly legal
    // characters in a dom node id
    // NB: This fails if the filename contains a double quote
    var node = $j('[id="radio_' + filename + '"]');
    var previousFilename = $cd.currentFilename();
    var previous = $j('[id="radio_' + previousFilename + '"]');
    $cd.radioEntrySwitch(previous, node);
    $cd.setRenameAndDeleteButtons(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.radioEntrySwitch = function(previous, current) {
    // Used by the run-tests-page filename radio-list
    // and also the create-page languages/exercises radio-lists
    // See the comment for makeFileListEntry() in
    // cyberdojo-files.js
    $cd.deselectRadioEntry(previous.parent());
    $cd.selectRadioEntry(current);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  $cd.deselectRadioEntry = function(node) {
    // See makeFileListEntry()

    // before loadFile() calls selectRadioEntry it does this...
    // $j('div[class="filename"]').each(function() {
    //   $cd.deselectRadioEntry($j(this));
    // });
    //Suggesting...selectRadioEntry can just be
    // 
    // $j('div[class="filename"]').each(function() {
    //   $j(this).attr('file_selected','false');
    // });
    // node.parent().attr('file_selected', 'true');
    // node.attr('checked', 'checked');        
    //
    // Except it may be better to do it as a class style
    // rather than file_selected.
    // build_diff_filename.js has
    //    filename.toggleClass('selected');
    
    node.attr('file_selected','false');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.selectRadioEntry = function(node) {
    // See makeFileListEntry()
    node.parent().attr('file_selected', 'true');
    node.attr('checked', 'checked');        
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.loadNextFile = function() {
    var filenames = $cd.filenames().sort();
    var index = $j.inArray($cd.currentFilename(), filenames);
    var nextFilename = filenames[(index + 1) % filenames.length];
    $cd.loadFile(nextFilename);  
  };
    
  return $cd;
})(cyberDojo || {}, $);

