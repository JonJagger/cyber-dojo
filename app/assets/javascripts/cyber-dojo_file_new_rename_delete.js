/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    $cd.newFileContent('newfile_' + $cd.random3(), 'Please rename me!');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.deleteFile = function(avatar_name) {
    $cd.deleteFilePrompt(avatar_name, true);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.renameFile = function(avatar_name) {
    var oldFilename = $cd.currentFilename();
    if ($cd.cantBeRenamedOrDeleted(oldFilename)) {
      return;
    }
    var div = $j('<div>', {
      'class': 'panel'
    });
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name, 100)));
    div.append('<div>&nbsp;</div>');
    var input = $j('<input>', {
      type: 'text',
      id: 'renamer',
      name: 'renamer',
      value: oldFilename
    });    
    div.append($cd.centeredDiv(input));
    var renamer = $j('<div>')
      .html(div)
      .dialog({
	autoOpen: false,
	width: 350,
	title: $cd.h2('rename'),
	modal: true,
	buttons: {
	  ok: function() {
	    $j(this).dialog('close');
	    var newFilename = $j.trim(input.val());
	    $cd.renameFileFromTo(avatar_name, oldFilename, newFilename);
	  },
	  cancel: function() {
	    $j(this).dialog('close');
	  }
	}
      });
    input.keyup(function(event) {
      event.preventDefault();
      var CARRIAGE_RETURN = 13;
      if (event.keyCode === CARRIAGE_RETURN) {
	var newFilename = $j.trim(input.val());
	renamer.dialog('close');
	$cd.renameFileFromTo(avatar_name, oldFilename, newFilename);
      }  
    });
    renamer.dialog('open');
    input[0].setSelectionRange(0, oldFilename.lastIndexOf('.'));
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.newFileContent = function(filename, content) {    
    $j('#visible_files_container').append($cd.makeNewFile(filename, content));
    $cd.bindLineNumbers(filename);      
    var current = $cd.currentFilename();
    $cd.rebuildFilenameList();
    $cd.loadFile(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.deleteFilePrompt = function(avatar_name, ask) {
    var filename = $cd.currentFilename();
    if ($cd.cantBeRenamedOrDeleted(filename)) {
      return;
    }
    var div = $j('<div>', {
      'class': 'panel'
    });    
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name, 100)));
    div.append('<div>&nbsp;</div>');
    div.append($cd.centeredDiv($cd.fakeFilenameButton(filename)));
    if (ask) {
      var deleter =
	$j('<div>')
	  .html(div)
	  .dialog({
	    autoOpen: false,
	    width: 350,
	    title: $cd.h2('delete'),
	    modal: true,
	    buttons: {
	      ok: function() {
		$cd.doDelete(filename);
		$j(this).dialog('close');
	      },
	      cancel: function() {
		$j(this).dialog('close');
	      }
	    }
	  });    
      deleter.dialog('open');
    } else {
      $cd.doDelete(filename);
    }
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.doDelete = function(filename) {
    $cd.fileDiv(filename).remove();    
    var filenames = $cd.rebuildFilenameList();
    // cyber-dojo.sh & output cannot be deleted so
    // there is always at least one file
    $cd.loadFile(filenames[0]);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.renameFileFromTo = function(avatar_name, oldFilename, newFilename) {
    $cd.saveScrollPosition(oldFilename);
    if ($cd.canRenameFileFromTo(avatar_name, oldFilename, newFilename)) {	  
      $cd.rewireFileFromTo(oldFilename, newFilename);	  
      $cd.rebuildFilenameList();
      $cd.loadFile(newFilename);
    }
    // else
    //   the scroll position is still ok but the
    //   cursor position is now lost... doing
    //     $cd.fileContentFor(oldFilename).focus();
    //     $cd.restoreScrollPosition(oldFilename);
    //   does not work - there is some interaction between
    //   jQuery dialog and the textarea cursor...??
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.canRenameFileFromTo = function(avatar_name, oldFilename, newFilename) {
    var message;
    if (newFilename === "") {
      message = "No filename entered" + "<br/>" +
	    "Rename " + oldFilename + " abandoned";
      $cd.renameAlert(avatar_name, message);
      return false;
    }
    if (newFilename === oldFilename) {
      message = "Same filename entered." + "<br/>" +
	    oldFilename + " is unchanged";
      $cd.renameAlert(avatar_name, message);
      return false;
    }
    if ($cd.filenameAlreadyExists(newFilename)) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return false;
    }
    if (newFilename.indexOf("/") !== -1) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    newFilename + " contains a forward slash");
      return false;
    }
    if (newFilename.indexOf("\\") !== -1) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    newFilename + " contains a back slash");
      return false;
    }
    return true;    
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.rewireFileFromTo = function(oldFilename, newFilename) {
    // I used to delete the old file and then create
    // a new one with the deleted file's content.
    // However, rewiring the existing dom node is better
    // since it is much easier to retain its cursor
    // and scroll positions that way.
    //
    // See ap/views/kata/_editor.html.erb
    //    <div class="filename_div"
    //         name="<%= filename %>"
    //         id="<% filename %>_div">
    var div = $cd.id(oldFilename + '_div');
    div.attr('name', newFilename);
    div.attr('id', newFilename + '_div');
    //        <textarea class="line_numbers"
    //                  id="<% filename %>_line_numbers">
    var nos = $cd.id(oldFilename + '_line_numbers');
    nos.attr('id', newFilename + '_line_numbers');
    //        <textarea class="file_content"
    //                  name="file_content['<% filename %>']"
    //                  id="file_content_for_<% filename %>"
    var ta = $cd.id('file_content_for_' + oldFilename);
    ta.attr('name', "file_content['" + newFilename + "']");
    ta.attr('id', 'file_content_for_' + newFilename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.renameFailure = function(avatar_name, oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "Cannot rename" + br +
	   tab + oldFilename + br +
	   "to" + br + 
	   tab + newFilename + br +
	  "because " + reason + ".";
    $cd.renameAlert(avatar_name, why);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.renameAlert = function(avatar_name, message) {
    var imageSize = 100;
    var imageHtml = ''
      + '<img alt="' + avatar_name + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar_name + '.jpg'+ '"'
      +     ' title="' + avatar_name + '" />';
    var alertHtml = ''    
      + '<div class="panel">'
      +   $cd.makeTable(imageHtml, message)
      + '</div>';
    $cd.dialog(alertHtml, 400, '!rename');
  };

  return $cd;
})(cyberDojo || {}, $);
