/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // delete file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(title) {
    var filename = cd.currentFilename();
    var div = $('<div>', {
      'class': 'avatar-background'
    });
	  var deleter = $('<div>')
	    .html(div)
	    .dialog({
		    autoOpen: false,
		    width: 350,
		    title: cd.dialogTitle(title),
		    modal: true,
		    buttons: {
  		    ok: function() { cd.doDelete(filename); $(this).remove(); },
		      cancel: function() { $(this).remove(); }
		    }
	  });
    var input = $('<input>', {
      type: 'text',
      id: 'delete-filename',
      name: 'delete-filename',
      value: filename,
	    disabled: 'disabled'
    });
    div.append(input);
	  deleter.dialog('open');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // new file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFile = function(title) {
    var newFilename = 'filename' + cd.extensionFilename();
    var div = $('<div>', {
      'class': 'avatar-background'
    });
    var input = $('<input>', {
      type: 'text',
      id: 'new-filename',
      name: 'new-filename',
      value: newFilename
    });
    var okButton = {
	    id: 'new-file-ok',
	    text: 'ok',
	    disabled: !cd.isValidFilename(newFilename),
	    click: function() {
		    var newFilename = $.trim(input.val())
		    cd.newFileContent(newFilename, '');
		    $(this).remove();
	    }
	  };
	  var cancelButton = {
	    id: 'new-file-cancel',
	    text: 'cancel',
	    click: function() { $(this).remove(); }
	  };
    var newFileDialog = $('<div>')
      .html(div)
      .dialog({
		    autoOpen: false,
		    width: 350,
		    title: cd.dialogTitle(title),
		    modal: true,
		    buttons: [ okButton, cancelButton ]
      });

    div.append(input);

  	input.keyup(function(event) {
      var ok = $('#new-file-ok');
	    newFilename = $.trim(input.val());
      event.preventDefault();
	    if (cd.isValidFilename(newFilename))  {
        ok.button('enable');
		    if (event.keyCode === $.ui.keyCode.ENTER) {
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

  cd.renameFile = function(title) {
    var oldFilename = cd.currentFilename();
    var div = $('<div>', {
      'class': 'avatar-background'
    });
    var input = $('<input>', {
      type: 'text',
      id: 'rename-filename',
      name: 'rename-filename',
      value: oldFilename
    });
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
    var renameFileDialog = $('<div>')
      .html(div)
      .dialog({
		    autoOpen: false,
		    width: 350,
		    title: cd.dialogTitle(title),
		    modal: true,
		    buttons: [ okButton, cancelButton ]
      });

    div.append(input);

	  input.keyup(function(event) {
	    var newFilename = $.trim(input.val());
      var ok = $('#rename-file-ok');
      event.preventDefault();
	    if (cd.isValidFilename(newFilename))  {
        ok.button('enable');
		    if (event.keyCode === $.ui.keyCode.ENTER) {
		      cd.renameFileFromTo(oldFilename, newFilename);
		      renameFileDialog.remove();
		    }
	    } else {
        ok.button('disable');
	    }
    });

    renameFileDialog.dialog('open');

    var end = oldFilename.lastIndexOf('.');
    if (end === -1) {
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
    if (filename === "") { return false; }
    if (cd.filenameAlreadyExists(filename)) { return false; }
    if (filename.indexOf("\\") !== -1) { return false; }
    if (filename[0] === '/') { return false; }
    if (filename.indexOf("..") !== -1) { return false; }
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
