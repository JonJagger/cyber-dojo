
var cyberDojo = (function($cd, $j) {
  
  $cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    $cd.newFileContent('newfile_' + $cd.random3(), 'Please rename me!');
  };

  $cd.deleteFile = function(avatar_name) {
    $cd.deleteFilePrompt(avatar_name, true);
  };

  $cd.renameFile = function(avatar_name) {
    var oldFilename = $cd.currentFilename();
    if ($cd.cantBeRenamedOrDeleted(oldFilename)) {
      return;
    }
    var div = $j('<div class="panel">', {
      style: 'font-size: 2.0em;'  
    });
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name, 150)));
    div.append('<div>&nbsp;</div>');
    var input = $j('<input>', {
      type: 'text',
      id: 'renamer',
      name: 'renamer',
      value: 'was_' + oldFilename
    });    
    div.append($cd.centeredDiv(input));
    var renamer = $j('<div>')
      .html(div)
      .dialog({
	autoOpen: false,
        width: 350,	    	
	title: $cd.h1('rename'),
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
  };
  
  $cd.newFileContent = function(filename, content) {    
    $j('#visible_files_container').append($cd.makeNewFile(filename, content));
    $cd.bindLineNumbers(filename);      
    var current = $cd.currentFilename();
    $cd.rebuildFilenameList();
    $cd.fileDiv(current).hide();
    $cd.selectFileInFileList(filename);
    $cd.fileDiv($cd.currentFilename()).show();
  };

  $cd.deleteFilePrompt = function(avatar_name, ask) {
    var filename = $cd.currentFilename();
    if ($cd.cantBeRenamedOrDeleted(filename)) {
      return;
    }
    var div = $j('<div class="panel">', {
      style: 'font-size: 2.0em;'  
    });
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name, 150)));
    div.append('<div>&nbsp;</div>');
    div.append($cd.centeredDiv($cd.fakeFilenameButton(filename)));
    if (ask) {
      var deleter =
	$j("<div>")
	  .html(div)
	  .dialog({
	    autoOpen: false,
            width: 350,	    
	    title: $cd.h1('delete'),
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

  $cd.doDelete = function(filename) {
    $cd.fileDiv(filename).remove();    
    var filenames = $cd.rebuildFilenameList();
    // cyberdojo.sh & output cannot be deleted so
    // always at least one file
    $cd.loadFile(filenames[0]);
  };

  $cd.renameFileFromTo = function(avatar_name, oldFilename, newFilename) {
    var message;
    if (newFilename === "") {
      message = "No filename entered" + "<br/>" +
	    "Rename " + oldFilename + " abandoned";
      $cd.alert(avatar_name, message);
      return;
    }
    if (newFilename === oldFilename) {
      message = "Same filename entered." + "<br/>" +
	    oldFilename + " is unchanged";
      $cd.alert(avatar_name, message);
      return;
    }
    if ($cd.fileAlreadyExists(newFilename)) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return;
    }
    if (newFilename.indexOf("/") !== -1) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    newFilename + " contains a forward slash");
      return;
    }
    if (newFilename.indexOf("\\") !== -1) {
      $cd.renameFailure(avatar_name, oldFilename, newFilename,
		    newFilename + " contains a back slash");
      return;
    }
    // OK. Now do it...
    var file = $cd.fileContentFor(oldFilename);
    var content = file.val();
    $cd.deleteFilePrompt(false);
    $cd.newFileContent(newFilename, content);
    $cd.rebuildFilenameList();
    $cd.selectFileInFileList(newFilename);
  };

  $cd.renameFailure = function(avatar_name, oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "Cannot rename" + br +
	   tab + oldFilename + br +
	   "to" + br + 
	   tab + newFilename + br +
	  "because " + reason + ".";
    $cd.alert(avatar_name, why);
  };

  return $cd;
})(cyberDojo || {}, $j);
