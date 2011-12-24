
var cyberDojo = (function($cd, $j) {
  //public
  $cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // This is so there is no excuse not to rename it!
    $cd.newFileContent('newfile_' + $cd.random3(), 'Please rename me!', 0, 0, 0);
  };

  $cd.deleteFile = function() {
    $cd.deleteFilePrompt(true);
  };

  $cd.renameFile = function () {
    var oldFilename = $cd.currentFilename();
  
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
  //private
  $cd.newFileContent = function(filename, content, caretPos, scrollTop, scrollLeft) {
    $j('#visible_files_container')
      .append($cd.createHiddenInput(filename, 'content', content))
      .append($cd.createHiddenInput(filename, 'caret_pos', caretPos))
      .append($cd.createHiddenInput(filename, 'scroll_top', scrollTop))
      .append($cd.createHiddenInput(filename, 'scroll_left', scrollLeft));
  
    // Save _before_ rebulding filename list so as
    // not to lose latest edit
    $cd.saveFile($cd.currentFilename());
    $cd.rebuildFilenameList();
    // Select it so you can immediately rename it
    $cd.loadFile(filename);
  };

  $cd.deleteFilePrompt = function(ask) {
    var filename = $cd.currentFilename();
    
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
    $cd.fileContent(filename).remove();  
    $cd.fileCaretPos(filename).remove();
    $cd.fileScrollTop(filename).remove();  
    $cd.fileScrollLeft(filename).remove();
  
    var filenames = $cd.rebuildFilenameList();
    // cyberdojo.sh cannot be deleted so always at least one file
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

  $cd.rebuildFilenameList = function() {
    var filenameList = $j('#filename_list');
    filenameList.empty();
    var filenames = $cd.filenames().sort();
    $j.each(filenames, function(n, filename) {
      filenameList.append($cd.makeFileListEntry(filename));
    });
    return filenames;
  };
  
  $cd.alert = function(message, title) {
    $j('<div>')
      .html(message)
      .dialog({
	autoOpen: false,
	title: typeof(title) !== 'undefined' ? title : "alert",
	modal: true,
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
    if ($cd.fileAlreadyExists(newFilename))
    {
      $cd.renameFailure(oldFilename, newFilename,
		    "a file called " + newFilename + " already exists");
      return;
    }
    if (newFilename.indexOf("/") !== -1)
    {
      $cd.renameFailure(oldFilename, newFilename,
		    newFilename + " contains a forward slash");
      return;
    }
    
    // OK. Now do it...
    // Rename by deleting and recreating with previous content
    
    var editor = $j('#editor');
    var content = editor.val();
    var caretPos = editor.caretPos();
    var scrollTop = editor.scrollTop();
    var scrollLeft = editor.scrollLeft();
    
    $cd.deleteFilePrompt(false);
    $cd.newFileContent(newFilename, content, caretPos, scrollTop, scrollLeft);
    $cd.rebuildFilenameList();
    $cd.selectFileInFileList(newFilename);
  };

  $cd.fileAlreadyExists = function(filename) {
    return $j.inArray(filename, $cd.filenames()) !== -1;
  };
  
  $cd.createHiddenInput = function(filename, aspect, value) {
    return $j("<input>", {
      type: 'hidden',
      name: 'file_' + aspect + "['" + filename + "']",
      id: 'file_' + aspect + '_for_' + filename,
      value: value
    });
  };

  $cd.filenames = function() {  
    var prefix = 'file_content_for_';
    var filenames = [ ];
    $j('input[id^="' + prefix + '"]').each(function(index) {
      var id = $j(this).attr('id');
      var filename = id.substr(prefix.length, id.length - prefix.length);
      filenames.push(filename);
    });
    return filenames;
  };

  $cd.makeFileListEntry = function(filename) {
    var div = $j("<div>", {
      'class': 'mid_tone filename'
    });
  
    div.click(function() {
      $cd.saveFile($cd.currentFilename());
      $cd.loadFile(filename);
    });
    
    div.append($j("<input>", {
      id: 'radio_' + filename,
      name: 'filename',
      type: 'radio',
      value: filename   
    }));
    
    div.append($j("<label>", {
      text: ' ' + filename
    }));
    
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



