/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.newFile = function(title) {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    cd.newFileContent('newfile_' + cd.random3(), 'Please rename me!');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(title, avatarName) {
    cd.deleteFilePrompt(title, avatarName, true);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(title, avatarName) {
    var oldFilename = cd.currentFilename();
    var div = $('<div>', {
      'class': 'panel'
    });
    var input = $('<input>', {
      type: 'text',
      id: 'renamer',
      name: 'renamer',
      value: oldFilename
    });

    div.append(cd.centeredDiv(cd.avatarImage(avatarName, 50)));
    div.append('<div>&nbsp;</div>');
    div.append(cd.centeredDiv(input));
	
    var renamer = $('<div>')
      .html(div)
      .dialog({
		autoOpen: false,
		width: 350,
		title: cd.dialogTitle(title),
		modal: true,
		buttons: [
		  {
			id: 'rename_ok',
			text: 'ok',
			disabled: true,
			click: function() {
			  console.log("CLICKED");
			  var newFilename = $.trim(input.val());
			  cd.renameFileFromTo(avatarName, oldFilename, newFilename);
			  $(this).remove();
		    }
		  },
		  {
			id: 'rename_cancel',
			text: 'cancel',
			click: function() {
			  $(this).remove();
			}
		  }
		]
      });
	
	input.keyup(function(event) {
	  var newFilename = $.trim(input.val());
      var renameOk = $('#rename_ok');
      event.preventDefault();
	  if (cd.isValidFilename(newFilename))  {
        renameOk.button('enable');
		if (event.keyCode === $.ui.keyCode.ENTER) {
		 cd.renameFileFromTo(avatarName, oldFilename, newFilename);		
		 renamer.remove();
		}  		
	  } else {
        renameOk.button('disable');
	  }
    });
		
    renamer.dialog('open');
    var end = oldFilename.lastIndexOf('.');
    if (end === -1) {
      end = oldFilename.length;
    }
    input[0].setSelectionRange(0, end);
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFileContent = function(filename, content) {
	var newFile = cd.makeNewFile(filename, content);
    $('#visible_files_container').append(newFile);
    cd.bindLineNumbers(filename);      
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFilePrompt = function(title, avatarName, ask) {
    var filename = cd.currentFilename();
    var div = $(cd.divPanel(''));
    div.append(cd.centeredDiv(cd.avatarImage(avatarName, 50)));
    div.append('<div>&nbsp;</div>');
    div.append(cd.centeredDiv(cd.fakeFilenameButton(filename)));
    if (ask) {
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
			  $(this).dialog('close');
			},
			cancel: function() {
			  $(this).dialog('close');
			}
		  }
		});    
      deleter.dialog('open');
    }
	else {
      cd.doDelete(filename);
    }
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  cd.renameFileFromTo = function(avatarName, oldFilename, newFilename) {
    cd.saveScrollPosition(oldFilename);
	//TODO: once live rename checks are fully in place drop this if
	//      but retain if contents.
    if (cd.canRenameFileFromTo(avatarName, oldFilename, newFilename)) {	  
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

  cd.canRenameFileFromTo = function(avatarName, oldFilename, newFilename) {
    var message;
    if (newFilename === "") {
      message = "No filename entered" + "<br/>" +
	    "Rename " + oldFilename + " abandoned";
      cd.renameAlert(avatarName, message);
      return false;
    }
    if (newFilename === oldFilename) {
      message = "Same filename entered." + "<br/>" +
	    oldFilename + " is unchanged";
      cd.renameAlert(avatarName, message);
      return false;
    }
    if (cd.filenameAlreadyExists(newFilename)) {
      cd.renameFailure(avatarName, oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return false;
    }
    if (newFilename.indexOf("\\") !== -1) {
      cd.renameFailure(avatarName, oldFilename, newFilename,
		    newFilename + " contains a back slash");
      return false;
    }
    if (newFilename[0] === '/') {
      cd.renameFailure(avatarName, oldFilename, newFilename,
		    newFilename + " starts with a forward slash");
      return false;      
    }
    if (newFilename.indexOf("..") !== -1) {
      cd.renameFailure(avatarName, oldFilename, newFilename,
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

  cd.renameFailure = function(avatarName, oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "Cannot rename" + br +
	   tab + oldFilename + br +
	   "to" + br + 
	   tab + newFilename + br +
	  "because " + reason;
    cd.renameAlert(avatarName, why);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.renameAlert = function(avatarName, message) {
	var imageSize = 50;
    var imageHtml = ''
      + '<img alt="' + avatarName + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatarName + '.jpg'+ '"'
      +     ' title="' + avatarName + '" />';      
    var alertHtml = ''    
      + '<div class="panel" data-width="400">'
      +   cd.makeTable(imageHtml, message)
      + '</div>';
    var ok = "ok";
    cd.dialog(alertHtml, '!rename', ok).dialog('open');
  };

  return cd;
})(cyberDojo || {}, $);
