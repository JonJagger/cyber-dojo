/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    cd.newFileContent('newfile_' + cd.random3(), 'Please rename me!');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(avatarName) {
    cd.deleteFilePrompt(avatarName, true);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(avatarName) {
    var oldFilename = cd.currentFilename();
    if (cd.cantBeRenamedOrDeleted(oldFilename)) {
      return;
    }
    var div = $('<div>', {
      'class': 'panel'
    });
    div.append(cd.centeredDiv(cd.avatarImage(avatarName, 100)));
    div.append('<div>&nbsp;</div>');
    var input = $('<input>', {
      type: 'text',
      id: 'renamer',
      name: 'renamer',
      value: oldFilename
    });
    div.append(cd.centeredDiv(input));
    var renamer = $('<div>')
      .html(div)
      .dialog({
		autoOpen: false,
		width: 350,
		title: cd.dialogTitle('rename'),
		modal: true,
		buttons: {
		  ok: function() {
			$(this).dialog('close');
			var newFilename = $.trim(input.val());
			cd.renameFileFromTo(avatarName, oldFilename, newFilename);
		  },
		  cancel: function() {
			$(this).dialog('close');
		  }
		}
      });
    
	input.keyup(function(event) {
      event.preventDefault();
      var CARRIAGE_RETURN = 13;
      if (event.keyCode === CARRIAGE_RETURN) {
		var newFilename = $.trim(input.val());
		renamer.dialog('close');
		cd.renameFileFromTo(avatarName, oldFilename, newFilename);
      }  
    });
	
    renamer.dialog('open');
    input[0].setSelectionRange(0, oldFilename.lastIndexOf('.'));
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFileContent = function(filename, content) {    
    $('#visible_files_container').append(cd.makeNewFile(filename, content));
    cd.bindLineNumbers(filename);      
    var current = cd.currentFilename();
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFilePrompt = function(avatarName, ask) {
    var filename = cd.currentFilename();
    if (cd.cantBeRenamedOrDeleted(filename)) {
      return;
    }
    var div = $(cd.divPanel(''));
    div.append(cd.centeredDiv(cd.avatarImage(avatarName, 100)));
    div.append('<div>&nbsp;</div>');
    div.append(cd.centeredDiv(cd.fakeFilenameButton(filename)));
    if (ask) {
      var deleter = $('<div>')
		.html(div)
		.dialog({
		  autoOpen: false,
		  width: 350,
		  title: cd.dialogTitle('delete'),
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
    } else {
      cd.doDelete(filename);
    }
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.doDelete = function(filename) {
    cd.fileDiv(filename).remove();    
    var filenames = cd.rebuildFilenameList();
    // cyber-dojo.sh & output cannot be deleted so
    // there is always at least one file
    cd.loadFile(filenames[0]);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFileFromTo = function(avatarName, oldFilename, newFilename) {
    cd.saveScrollPosition(oldFilename);
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
    // See ap/views/kata/_editor.html.erb
    //    <div class="filename_div"
    //         name="<%= filename %>"
    //         id="<%= filename %>_div">
    var div = cd.id(oldFilename + '_div');
    div.attr('name', newFilename);
    div.attr('id', newFilename + '_div');
    //        <textarea class="line_numbers"
    //                  id="<%= filename %>_line_numbers">
    var nos = cd.id(oldFilename + '_line_numbers');
    nos.attr('id', newFilename + '_line_numbers');
    //        <textarea class="file_content"
    //                  name="file_content['<%= filename %>']"
    //                  id="file_content_for_<%= filename %>"
    var ta = cd.id('file_content_for_' + oldFilename);
    ta.attr('name', "file_content['" + newFilename + "']");
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
    var imageSize = 100;
    var imageHtml = ''
      + '<img alt="' + avatarName + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatarName + '.jpg'+ '"'
      +     ' title="' + avatarName + '" />';      
    var alertHtml = ''    
      + '<div class="panel">'
      +   cd.makeTable(imageHtml, message)
      + '</div>';
    cd.dialog(alertHtml, 400, '!rename');
  };

  return cd;
})(cyberDojo || {}, $);
