/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // delete file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(title) {
    var filename = cd.currentFilename();
    var div = $(cd.divPanel(''));
	var deleter = $('<div>')
	  .html(div)
	  .dialog({
		autoOpen: false,
		width: 350,
		title: cd.dialogTitle(title),
		modal: true,
		buttons: {
		  ok: function() {
			cd.doDelete(filename);
			$(this).remove();
		  },
		  cancel: function() {
			$(this).remove();
		  }
		}
	  });
    var input = $('<input>', {
      type: 'text',
      value: filename,
	  disabled: "disabled"
    });
    div.append(input);
	deleter.dialog('open');
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.doDelete = function(filename) {
	// Also used in cyber-dojo_dialog_revert.js
    cd.fileDiv(filename).remove();
    var filenames = cd.rebuildFilenameList();
	var i = cd.nonBoringFilenameIndex(filenames);
    cd.loadFile(filenames[i]);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // new file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFile = function(title) {
    var newFilename = 'filename' + cd.extensionFilename();
    var div = $('<div>', {
      'class': 'panel'
    });
    var input = $('<input>', {
      type: 'text',
      id: 'new_filename',
      name: 'new_filename',
      value: newFilename
    });
    var okButton =
	{
	  id: 'new_file_ok',
	  text: 'ok',
	  disabled: !cd.isValidFilename(newFilename),
	  click: function() {
		var newFilename = $.trim(input.val())
		cd.newFileContent(newFilename, '');
		// hack to ensure if line-numbers are off
		// then they are not initially displayed
		$('#line_numbers_button').click();
		$('#line_numbers_button').click();
		$(this).remove();
	  }
	};
	var cancelButton =
	{
	  id: 'new_file_cancel',
	  text: 'cancel',
	  click: function() {
		$(this).remove();
	  }
	};
    var newFileDialog = $('<div id="new_file_dialog">')
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
      var ok = $('#new_file_ok');
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

	// Don't refactor to newFileDialog.dialog('open')
	// If you do that the dialog only works the first time. See
	// http://praveenbattula.blogspot.co.uk/2009/08/jquery-dialog-open-only-once-solution.html
    $('#new_file_dialog').dialog('open');
    input[0].setSelectionRange(0, newFilename.length);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.newFileContent = function(filename, content) {
	// Also used in cyber-dojo_dialog_revert.js
	var newFile = cd.makeNewFile(filename, content);
    $('#visible-files-container').append(newFile);
    cd.bindLineNumbers(filename);
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // rename file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(title) {
    var oldFilename = cd.currentFilename();
    var div = $('<div>', {
      'class': 'panel'
    });
    var input = $('<input>', {
      type: 'text',
      id: 'rename_filename',
      name: 'rename_filename',
      value: oldFilename
    });
    var okButton =
	{
	  id: 'rename_file_ok',
	  text: 'ok',
	  disabled: !cd.isValidFilename(oldFilename),
	  click: function() {
		var newFilename = $.trim(input.val());
		cd.renameFileFromTo(oldFilename, newFilename);
		$(this).remove();
	  }
	};
	var cancelButton =
	{
	  id: 'rename_file_cancel',
	  text: 'cancel',
	  click: function() {
		$(this).remove();
	  }
	};
    var renameFileDialog = $('<div id="rename_file_dialog">')
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
      var ok = $('#rename_file_ok');
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

	// Don't refactor to renamer.dialog('open')
	// If you do that the dialog only works the first time. See
	// http://praveenbattula.blogspot.co.uk/2009/08/jquery-dialog-open-only-once-solution.html
    $('#rename_file_dialog').dialog('open');
    var end = oldFilename.lastIndexOf('.');
    if (end === -1) {
      end = oldFilename.length;
    }
    input[0].setSelectionRange(0, end);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.renameFileFromTo = function(oldFilename, newFilename) {
    cd.saveScrollPosition(oldFilename);
	cd.rewireFileFromTo(oldFilename, newFilename);
	cd.rebuildFilenameList();
	cd.loadFile(newFilename);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.rewireFileFromTo = function(oldFilename, newFilename) {
    // I used to delete the old file and then create
    // a new one with the deleted file's content.
    // However, rewiring the existing dom node is better
    // since it is much easier to retain its cursor
    // and scroll positions that way.
    //
    // See ap/views/kata/_visible_file.html.erb
    //    <div class="filename_div"
    //         id="<%= filename %>_div">
    var div = cd.id(oldFilename + '_div');
    div.attr('id', newFilename + '_div');
    //        <textarea class="line_numbers"
    //                  id="<%= filename %>_line_numbers">
    var nos = cd.id(oldFilename + '_line_numbers');
    nos.attr('id', newFilename + '_line_numbers');
    //        <textarea class="file_content"
    //                  name="file_content[<%= filename %>]"
    //                  id="file_content_for_<%= filename %>"
    var ta = cd.id('file_content_for_' + oldFilename);
	ta.data('filename', newFilename);
    ta.attr('name', "file_content[" + newFilename + "]");
    ta.attr('id', 'file_content_for_' + newFilename);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.isValidFilename = function(filename) {
	var tipWindow = $('#tip-window');
    if (filename === "") {
	  //cd.showTip('no filename', tipWindow);
      return false;
    }
    if (cd.filenameAlreadyExists(filename)) {
	  //cd.showTip('already exists', tipWindow);
      return false;
    }
    if (filename.indexOf("\\") !== -1) {
	  //cd.showTip("can't contain \\", tipWindow);
      return false;
    }
    if (filename[0] === '/') {
	  //cd.showTip("can't start with /", tipWindow);
      return false;
    }
    if (filename.indexOf("..") !== -1) {
	  //cd.showTip("can't contain ..", tipWindow);
      return false;
    }
    return true;
  };

  return cd;
})(cyberDojo || {}, $);
