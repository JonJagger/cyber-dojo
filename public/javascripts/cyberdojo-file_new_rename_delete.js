
var cyberDojo = (function($cd, $j) {
  
  $cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    $cd.newFileContent('newfile_' + $cd.random3(), 'Please rename me!');
  };

  $cd.deleteFile = function() {
    $cd.deleteFilePrompt(true);
  };

  $cd.renameFile = function () {
    var oldFilename = $cd.currentFilename();
    
    if ($cd.cantBeRenamedOrDeleted(oldFilename))
      return;
  
    var input = $j('<input>', {
      type: 'text',
      id: 'renamer',
      name: 'renamer',
      value: "was_" + oldFilename
    });
    
    var renamer = $j('<div>')
      .html(input)
      .dialog({
	autoOpen: false,
	title: "rename file to",
	modal: true,
	buttons: {
	  ok: function() {
	    $j(this).dialog('close');
	    var newFilename = $j.trim(input.val());
	    $cd.renameFileFromTo(oldFilename, newFilename);
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
	$cd.renameFileFromTo(oldFilename, newFilename);
      }  
    });
  
    renamer.dialog('open');
  };
  
  $cd.newFileContent = function(filename, content) {    
    $j('#visible_files_container')
      .append($cd.makeNewFile(filename, content));
      
    $cd.bindLineNumbers(filename);      
  
    var current = $cd.currentFilename();
    $cd.rebuildFilenameList();
    
    $cd.fileDiv(current).hide();
    $cd.selectFileInFileList(filename);
    $cd.fileDiv($cd.currentFilename()).show();
  };

  $cd.deleteFilePrompt = function(ask) {
    var filename = $cd.currentFilename();
    
    if ($cd.cantBeRenamedOrDeleted(filename))
      return;
    
    if (ask) {
      var deleter =
	$j("<div>")
	  .html(filename)
	  .dialog({
	    autoOpen: false,
	    title: "delete file",
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

  $cd.renameFailure = function(oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "CyberDojo could not rename" + br +
	   br +
	   tab + oldFilename + br +
	   "to" + br + 
	   tab + newFilename + br +
	   br +
	  "because " + reason + ".";
	  
    $cd.alert(why);
  };

  $cd.alert = function(message, title) {
    $j('<div>')
      .html(message)
      .dialog({
	autoOpen: false,
	title: typeof(title) !== 'undefined' ? title : "alert",
	modal: true,
	width: 400,
	buttons: {
	  ok: function() {
	    $j(this).dialog('close');
	  }
	}
      })
      .dialog('open');  
  };

  $cd.renameFileFromTo = function(oldFilename, newFilename) {
    var message;
    if (newFilename === "") {
      message = "No filename entered" + "<br/>" +
	    "Rename " + oldFilename + " abandoned";
      $cd.alert(message);
      return;
    }
    if (newFilename === oldFilename) {
      message = "Same filename entered." + "<br/>" +
	    oldFilename + " is unchanged";
      $cd.alert(message);
      return;
    }
    if ($cd.fileAlreadyExists(newFilename)) {
      $cd.renameFailure(oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return;
    }
    if (newFilename.indexOf("/") !== -1) {
      $cd.renameFailure(oldFilename, newFilename,
		    newFilename + " contains a forward slash");
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

  $cd.currentFilename = function() {
    return $j('#current_filename').val();
  };

  $cd.fileAlreadyExists = function(filename) {
    return $j.inArray(filename, $cd.filenames()) !== -1;
  };
    
  $cd.rebuildFilenameList = function() {
    var filenames = $cd.filenames();    
    filenames.sort();
    var filenameList = $j('#filename_list');
    filenameList.empty();
    $j.each(filenames, function(n, filename) {
      filenameList.append($cd.makeFileListEntry(filename));
    });
    return filenames;
  };
  
  $cd.filenames = function() {  
    var prefix = 'file_content_for_';
    var filenames = [ ];
    $j('textarea[id^="' + prefix + '"]').each(function(index) {
      var id = $j(this).attr('id');
      var filename = id.substr(prefix.length, id.length - prefix.length);
      filenames.push(filename);
    });
    return filenames;
  };

  $cd.makeFileListEntry = function(filename) {
    var div = $j('<div>', {
      'class': 'filename'
    });
  
    div.click(function() {
      $cd.loadFile(filename);
    });
    
    div.append($j('<input>', {
      id: 'radio_' + filename,
      name: 'filename',
      type: 'radio',
      value: filename   
    }));
    
    div.append($j('<label>', {
      text: ' ' + filename
    }));
    
    return div;
  };
  
  $cd.makeNewFile = function(filename, content) {
    var div = $j('<div>', {
      'class': 'filename_div',
      name: filename,
      id: filename + '_div'
    });
    var table = $j('<table>', {
      cellspacing: '0',
      cellpadding: '0'
    });
    var tr = $j('<tr>');
    var td1 = $j('<td>');
    var lines = $j('<textarea>', {
      'class': 'line_numbers',
      name: filename + '_line_numbers',
      id: filename + '_line_numbers'
    });
    var td2 = $j('<td>');
    var text = $j('<textarea>', {
      'class': 'file_content',
      name: "file_content['" + filename + "']",
      id: 'file_content_for_' + filename,
      wrap: 'off'
    });
    text.val(content);        
    td1.append(lines);
    tr.append(td1);
    td2.append(text);
    tr.append(td2);
    table.append(tr);
    div.append(table);

    $cd.bindHotKeys(text);
    $cd.tabber(text);
    
    return div;
  };

  $cd.randomAlphabet = function() {
    return '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';  
  };

  $cd.randomChar = function() {
    var alphabet = $cd.randomAlphabet();
    return alphabet.charAt($cd.rand(alphabet.length));
  };
    
  $cd.random3 = function() {
    return $cd.randomChar() + $cd.randomChar() + $cd.randomChar();
  };
  
  $cd.rand = function(n) {
    return Math.floor(Math.random() * n);
  };

  return $cd;
})(cyberDojo || {}, $j);



