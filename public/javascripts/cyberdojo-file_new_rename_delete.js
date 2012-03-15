
var cyberDojo = (function($cd, $j) {
  
  $cd.newFile = function() {
    // Append three random chars to the end of the filename.
    // There is no excuse not to rename it!
    $cd.newFileContent('newfile_' + $cd.random3(), 'Please rename me!');
  };

  $cd.deleteFile = function(avatar_name) {
    $cd.deleteFilePrompt(avatar_name, true);
  };

  $cd.centeredDiv = function(node) {
    var div = $j('<div>', {
     align: 'center' 
    });
    div.append(node);
    return div;
  };
  
  $cd.avatarImage = function(avatar_name) {
    var imageSize = 150;
    return $j('<img>', {
       alt: avatar_name,
      'class': "avatar_image",
      'height': imageSize,
      'width': imageSize,
       src: "/images/avatars/" + avatar_name + ".jpg",
       title: avatar_name
    });
  };

  $cd.renameFile = function(avatar_name) {
    var oldFilename = $cd.currentFilename();
    
    if ($cd.cantBeRenamedOrDeleted(oldFilename))
      return;
  
    var div = $j('<div class="panel">', {
      style: 'font-size: 2.0em;'  
    });
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name)));
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

  $cd.htmlPanel = function(content) {
    return '<div class="panel" style="font-size: 2.0em;">' + content + '</div>'
  };

  $cd.deleteFilePrompt = function(avatar_name, ask) {
    var filename = $cd.currentFilename();
    
    if ($cd.cantBeRenamedOrDeleted(filename)) {
      return;
    }
    
    var div = $j('<div class="panel">', {
      style: 'font-size: 2.0em;'  
    });
    div.append($cd.centeredDiv($cd.avatarImage(avatar_name)));
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

  $cd.renameFailure = function(oldFilename, newFilename, reason) {
    var space = "&nbsp;";
    var tab = space + space + space + space;
    var br = "<br/>";
    var why = "Cannot not rename" + br +
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
      .html($cd.htmlPanel(message))
      .dialog({
	autoOpen: false,
	title: typeof(title) !== 'undefined' ? $cd.h1(title) : $cd.h1('alert!'),
	modal: true,
	width: 600,
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
    if (newFilename.indexOf("\\") !== -1) {
      $cd.renameFailure(oldFilename, newFilename,
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

  $cd.currentFilename = function() {
    // I tried changing this to...
    //   return $j('input:radio[name=filename]:checked').val();
    // (which would remove the need for the file
    //    cyberdojo/app/views/_current_filename.html.erb)
    // This worked on Firefox but not on Chrome and the issue
    // in Chrome was in the function
    //   $cd.loadFile = function(filename) {
    //      $cd.fileDiv($cd.currentFilename()).hide();
    //      $cd.selectFileInFileList(filename);
    //   };
    // in cyberdojo-file_load_save.js
    // It seems in Chrome $cd.currentFilename() gets
    // the filename _after_ the html input radio selection has
    // taken place. The effect is that the old filename stays
    // open and the new filename is hidden and then reshown!
    
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
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Creates a filename entry on the run-tests page. I can't stand
    // radio-lists that have differing length text and you have to
    // click exactly on the text rather than on the space after
    // the text when its one of the shorter texts. So this has extra
    // structure. The <input type="radio"...> entries are wrapped
    // inside a <div class="filename"> and it is to the div that the
    // click handler function is attached. This pattern repeats
    // in the language and exercise radio-lists in the create-page
    // and also in the diff-page filename list.
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
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
  
  $cd.deselectRadioEntry = function(node) {  
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // See makeFileListEntry() above...
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    node.css('background-color', '#B2EFEF');
    node.css('color', '#777');
  };

  $cd.selectRadioEntry = function(node) {
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // See makeFileListEntry() above...
    // I colour the radio entry in jQuery rather than in
    // explicit CSS to try and give better ui appearance in
    // older browsers.    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    node.parent().css('background-color', 'Cornsilk');
    node.parent().css('color', '#003C00');
    node.attr('checked', 'checked');        
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



