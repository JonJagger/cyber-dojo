/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var dialogWidth = 250;

  var fileTitle = function(name) {
    return name + '&nbsp;' + 'file';
  };

  var makeAvatarImage = function(avatar) {
    return $('<img>', {
        'src': '/images/avatars/' + avatar + '.jpg',
      'style': 'width:214px'
    });
  };

  var makeInput = function(name, filename) {
    var input = $('<input>', {
      type: 'text',
      id: name+'-filename',
      'name': name+'-filename',
      value: filename
    });
    if (name == 'delete') {
      input.attr('disabled', 'disabled');
    }
    return input;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // delete file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(avatar) {
    var filename = cd.currentFilename();
    var input = makeInput('delete', filename);
    var div = $('<div>');
	  var deleter = div.dialog({
      closeOnEscape: true,
      close: function() { $(this).remove(); },
      title: cd.dialogTitle(fileTitle('delete')),
      autoOpen: false,
      width: dialogWidth,
      modal: true,
      buttons: { ok: function() { cd.doDelete(filename); $(this).remove(); },
                 cancel: function() { $(this).remove(); }
               }
	  });
    div.append(input);
    div.append(makeAvatarImage(avatar));
    deleter.dialog('open');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // new file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFile = function(avatar) {
    var newFilename = 'filename' + cd.extensionFilename();
    var input = makeInput('new', newFilename);
    var okButton = {
      id: 'new-file-ok',
      text: 'ok',
      disabled: !cd.isValidFilename(newFilename),
      click: function() {
        var newFilename = $.trim(input.val());
        cd.newFileContent(newFilename, '');
        $(this).remove();
      },
    };
	  var cancelButton = {
      id: 'new-file-cancel',
      text: 'cancel',
      click: function() { $(this).remove(); }
    };
    var div = $('<div>');
    var newFileDialog = div.dialog({
      closeOnEscape: true,
      close: function() { $(this).remove(); },
    	title: cd.dialogTitle(fileTitle('new')),
    	autoOpen: false,
      width: dialogWidth,
    	modal: true,
      buttons: [ okButton, cancelButton ]
    });

    div.append(input);
    div.append(makeAvatarImage(avatar));

  	input.keyup(function(event) {
      var ok = $('#new-file-ok');
      newFilename = $.trim(input.val());
      event.preventDefault();
      if (cd.isValidFilename(newFilename))  {
        ok.button('enable');
        if (event.keyCode == $.ui.keyCode.ENTER) {
          cd.newFileContent(newFilename, '');
          newFileDialog.remove();
        }
      } else {
        ok.button('disable');
      }
    });

    newFileDialog.dialog('open');
    input[0].setSelectionRange(0, newFilename.length);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // rename file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(avatar) {
    var oldFilename = cd.currentFilename();
    var input = makeInput('rename', oldFilename);
    var okButton = {
      id: 'rename-file-ok',
      text: 'ok',
      disabled: !cd.isValidFilename(oldFilename),
      click: function() {
        var newFilename = $.trim(input.val());
        cd.renameFileFromTo(oldFilename, newFilename);
        $(this).remove();
      }
    };
    var cancelButton = {
      id: 'rename-file-cancel',
      text: 'cancel',
      click: function() { $(this).remove(); }
    };
    var div = $('<div>');
    var renameFileDialog = div.dialog({
      closeOnEscape: true,
      close: function() { $(this).remove(); },
      title: cd.dialogTitle(fileTitle('rename')),
      autoOpen: false,
      width: dialogWidth,
      modal: true,
      buttons: [ okButton, cancelButton ]
    });

    div.append(input);
    div.append(makeAvatarImage(avatar));

    input.keyup(function(event) {
      var newFilename = $.trim(input.val());
      var ok = $('#rename-file-ok');
      event.preventDefault();
      if (cd.isValidFilename(newFilename))  {
        ok.button('enable');
        if (event.keyCode == $.ui.keyCode.ENTER) {
          cd.renameFileFromTo(oldFilename, newFilename);
          renameFileDialog.remove();
        }
      } else {
        ok.button('disable');
      }
    });

    renameFileDialog.dialog('open');

    var end = oldFilename.lastIndexOf('.');
    if (end == -1) {
      end = oldFilename.length;
    }
    input[0].setSelectionRange(0, end);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.renameFileFromTo = function(oldFilename, newFilename) {
    var oldFile = cd.fileContentFor(oldFilename);
    var content = oldFile.val();
    var scrollTop = oldFile.scrollTop();
    var scrollLeft = oldFile.scrollLeft();
    var caretPos = oldFile.caret();
    $(oldFile).closest('tr').remove();

    cd.newFileContent(newFilename, content);
    cd.rebuildFilenameList();
    cd.loadFile(newFilename);
    var newFile = cd.fileContentFor(newFilename);
    // Note that doing the seemingly equivalent
    //   fc.scrollTop(top);
    //   fc.scrollLeft(left);
    // here does _not_ work. I use animate instead with a
    // very fast duration==1 and that does work!
    newFile.animate({scrollTop:scrollTop, scrollLeft:scrollLeft}, 1);
    newFile.caret(caretPos);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.isValidFilename = function(filename) {
    var contains = function(illegal) { return filename.indexOf(illegal) != -1; };
    if (cd.filenameAlreadyExists(filename)) { return false; }
    if (contains('..')) { return false; }
    if (contains('\\')) { return false; }
    if (contains('/'))  { return false; }
    if (contains(' '))  { return false; }
    if (filename == '') { return false; }
    return true;
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
  // These two functions are also used in the
  // revert functionality in cyber-dojo_dialog_history.js

  cd.newFileContent = function(filename, content) {
    var newFile = cd.makeNewFile(filename, content);
    $('#visible-files-container').append(newFile);
    cd.bindLineNumbers(filename);
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

  cd.doDelete = function(filename) {
    cd.fileDiv(filename).remove();
    var filenames = cd.rebuildFilenameList();
    var i = cd.nonBoringFilenameIndex(filenames);
    cd.loadFile(filenames[i]);
  };

  return cd;

})(cyberDojo || {}, $);
