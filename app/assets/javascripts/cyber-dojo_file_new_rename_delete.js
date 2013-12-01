/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.deleteFile = function(title) {
    var filename = cd.currentFilename();
    var div = $(cd.divPanel(''));
    div.append(cd.centeredDiv(cd.fakeFilenameButton(filename)));
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
	deleter.dialog('open');
  };

  cd.doDelete = function(filename) {
	var i, filenames, notBoring;
    cd.fileDiv(filename).remove();    
    filenames = cd.rebuildFilenameList();
    // cyber-dojo.sh & output cannot be deleted so
    // there is always at least one file. But
	// they are boring files, and so is instructions
	// so try to avoid those three...
	for (i = 0; i < filenames.length; i++) {
	  notBoring = filenames[i];
	  if (notBoring !== 'cyber-dojo.sh' &&
		  notBoring !== 'intstructions' &&
		  notBoring !== 'output') {
		break;
	  }
	}
	if (i === filenames.length) {
	  i = 0;
	}
    cd.loadFile(filenames[i]);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.newFile = function(title) {
    var newFilename = 'filename';
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
		var newFilename = $.trim(input.val());
        cd.newFileContent(newFilename, '');		
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
	
    div.append(cd.centeredDiv(input));		
	
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

  cd.newFileContent = function(filename, content) {
	var newFile = cd.makeNewFile(filename, content);
    $('#visible_files_container').append(newFile);
    cd.bindLineNumbers(filename);      
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

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
	
    div.append(cd.centeredDiv(input));		
	
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
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFileFromTo = function(oldFilename, newFilename) {
    cd.saveScrollPosition(oldFilename);
	//TODO: once live rename checks are fully in place drop this if
	//      but retain if contents.
    if (cd.canRenameFileFromTo(oldFilename, newFilename)) {	  
      cd.rewireFileFromTo(oldFilename, newFilename);	  
      cd.rebuildFilenameList();
      cd.loadFile(newFilename);
    }
    // else
    //   the scroll position is still ok but the
    //   cursor position is now lost... doing
    //     cd.fileContentFor(oldFilename).focus();
    //     cd.restoreScrollPosition(oldFilename);
    //   does not work - there is some interaction between
    //   jQuery dialog and the textarea cursor...??
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.isValidFilename = function(filename) {
    if (filename === "") {
      return false;
    }
    if (cd.filenameAlreadyExists(filename)) {
      return false;
    }
    if (filename.indexOf("\\") !== -1) {
      return false;
    }
    if (filename[0] === '/') {
      return false;      
    }
    if (filename.indexOf("..") !== -1) {
      return false;      
    }
    return true;    	
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.canRenameFileFromTo = function(oldFilename, newFilename) {
    var message;
    if (newFilename === "") {
      message = "No filename entered" + "<br/>" +
	    "Rename " + oldFilename + " abandoned";
      cd.renameAlert(message);
      return false;
    }
    if (newFilename === oldFilename) {
      message = "Same filename entered." + "<br/>" +
	    oldFilename + " is unchanged";
      cd.renameAlert(message);
      return false;
    }
    if (cd.filenameAlreadyExists(newFilename)) {
      cd.renameFailure(oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return false;
    }
    if (newFilename.indexOf("\\") !== -1) {
      cd.renameFailure(oldFilename, newFilename,
		    newFilename + " contains a back slash");
      return false;
    }
    if (newFilename[0] === '/') {
      cd.renameFailure(oldFilename, newFilename,
		    newFilename + " starts with a forward slash");
      return false;      
    }
    if (newFilename.indexOf("..") !== -1) {
      cd.renameFailure(oldFilename, newFilename,
		    newFilename + " contains ..");
      return false;      
    }
    return true;    
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
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

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFailure = function(oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "Cannot rename" + br +
	   tab + oldFilename + br +
	   "to" + br + 
	   tab + newFilename + br +
	  "because " + reason;
    cd.renameAlert(why);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.renameAlert = function(message) {
    var alertHtml = ''    
      + '<div class="panel" data-width="400">'
      +   cd.makeTable(message)
      + '</div>';
    var ok = "ok";
    cd.dialog(alertHtml, '!rename', ok).dialog('open');
  };

  return cd;
})(cyberDojo || {}, $);
