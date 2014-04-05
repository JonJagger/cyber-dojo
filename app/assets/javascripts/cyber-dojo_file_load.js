/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.loadFile = function(filename) {
    // I want to
    //    1. restore scrollTop and scrollLeft positions
    //    2. restore focus (also restores cursor position)
    // Restoring the focus loses the scrollTop/Left
    // positions so I have to save them in the dom so
    // I can set them back _after_ the call to focus()
    // The call to focus() allows you to carry on
    // typing at the point the cursor left off.

    cd.saveScrollPosition(cd.currentFilename());
    cd.fileDiv(cd.currentFilename()).hide();
    cd.selectFileInFileList(filename);
    cd.fileDiv(filename).show();

    cd.fileContentFor(filename).focus();
    cd.restoreScrollPosition(filename);
    $('#current-filename').val(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.saveScrollPosition = function(filename) {
    var fc = cd.fileContentFor(filename);
    var top = fc.scrollTop();
    var left = fc.scrollLeft();
    var div = cd.fileDiv(filename);
    div.attr('scrollTop', top);
    div.attr('scrollLeft', left);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.restoreScrollPosition = function(filename) {
    // Restore the saved scrollTop/Left positions.
    // Note that doing the seemingly equivalent
    //   fc.scrollTop(top);
    //   fc.scrollLeft(left);
    // here does _not_ work. I use animate instead with a
    // very fast duration==1
    var div = cd.fileDiv(filename);
    var top = div.attr('scrollTop') || 0;
    var left = div.attr('scrollLeft') || 0;
    var fc = cd.fileContentFor(filename);
    fc.animate({scrollTop: top, scrollLeft: left}, 1);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.setRenameAndDeleteButtons = function(filename) {
    var fileOps = $('#file-operations');
    var newFile    = fileOps.find('#new');
    var renameFile = fileOps.find('#rename');
    var deleteFile = fileOps.find('#delete');

    var turnOff = function(node) {
      node.attr('disabled', true);
    };
    var turnOn = function(node) {
      node.removeAttr('disabled');
    };

    if (cd.cantBeRenamedOrDeleted(filename)) {
      turnOff(renameFile);
      turnOff(deleteFile);
    }
    else {
      turnOn(renameFile);
      turnOn(deleteFile);
    }
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.cantBeRenamedOrDeleted = function(filename) {
    var filenames = [ 'cyber-dojo.sh', 'output' ];
    return cd.inArray(filename, filenames);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.selectFileInFileList = function(filename) {
    // Can't do $('radio_' + filename) because filename
    // could contain characters that aren't strictly legal
    // characters in a dom node id so I do this instead...
    var node = $('[id="radio_' + filename + '"]');
    var previousFilename = cd.currentFilename();
    var previous = $('[id="radio_' + previousFilename + '"]');
    cd.radioEntrySwitch(previous, node);
    cd.setRenameAndDeleteButtons(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.radioEntrySwitch = function(previous, current) {
    // Used in test-page and diff-page and setup-page
    if (previous !== undefined) {
      previous.removeClass('selected');
    }
    current.addClass('selected');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.notLowlightFilenames = function() {
    var hilightFilenames = ['output'];
    var all = cd.filenames();
    all.sort();
    $.each(all, function(n, filename) {
      if (!cd.inArray(filename, cd.lowlightFilenames()) && filename !== 'output') {
        hilightFilenames.push(filename);
      }
    });
    return hilightFilenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.loadNextFile = function() {
    var hilightFilenames = cd.notLowlightFilenames();
    var index = $.inArray(cd.currentFilename(), hilightFilenames);
    if (index === -1) {
      index = 0; // output
    } else {
      index = (index + 1) % hilightFilenames.length;
    }
    cd.loadFile(hilightFilenames[index]);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.loadPreviousFile = function() {
    var hilightFilenames = cd.notLowlightFilenames();
    var index = $.inArray(cd.currentFilename(), hilightFilenames);
    if (index === 0 || index === -1) {
      index = hilightFilenames.length - 1;
    } else {
      index -= 1;
    }
    cd.loadFile(hilightFilenames[index]);
  };

  return cd;
})(cyberDojo || {}, $);
