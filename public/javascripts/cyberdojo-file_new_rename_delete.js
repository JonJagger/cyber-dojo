
function sortFilenames(filenames) 
{
  filenames.sort(function(lhs, rhs) 
    {
      if (lhs < rhs)
	return -1;
      else if (lhs > rhs)
	return 1;
      else
	return 0; // Should never happen (implies two files with same name)
    });
}

function rebuildFilenameList() 
{
  var filenames = allFilenames();
  sortFilenames(filenames);

  var filename_list = $j('#filename_list');
  filename_list.empty();
  $j.each(filenames, function(n, filename) {
    filename_list.append(makeFileListEntry(filename));
  });
}

function newFile() 
{
  // Append three random chars to the end of the filename.
  // This is so there is no excuse not to rename it!
  newFileContent('newfile_' + random3(), 'Please rename me!', 0, 0, 0);
}

function newFileContent(filename, content, caretPos, scrollTop, scrollLeft) 
{
  $j('#visible_files_container')
    .append(createHiddenInput(filename, 'content', content))
    .append(createHiddenInput(filename, 'caret_pos', caretPos))
    .append(createHiddenInput(filename, 'scroll_top', scrollTop))
    .append(createHiddenInput(filename, 'scroll_left', scrollLeft));

  // Save _before_ rebulding filename list so as
  // not to lose latest edit
  saveFile(currentFilename());
  rebuildFilenameList();
  // Select it so you can immediately rename it
  loadFile(filename);
}

function deleteFile() 
{
  deleteFilePrompt(true);
}

function deleteFilePrompt(ask) 
{
  var filename = currentFilename();
  
  var deleter =
    $j("<div>")
      .html(filename)
      .dialog({
	autoOpen: false,
	title: "delete file",
	modal: true,
	buttons: {
	  ok: function() {
	    doDelete(filename);
	    $j(this).dialog('close');
	  },
	  cancel: function() {
	    $j(this).dialog('close');
	  }
	}
      });
  
  if (ask)
    deleter.dialog('open');
  else
    doDelete(filename);
}

function doDelete(filename)
{
  fileContent(filename).remove();  
  fileCaretPos(filename).remove();
  fileScrollTop(filename).remove();  
  fileScrollLeft(filename).remove();

  rebuildFilenameList();
  var filenames = allFilenames();
  // cyberdojo.sh cannot be deleted so always at least one file
  loadFile(filenames[0]);
}

function renameFailure(oldFilename, newFilename, reason)
{
  var space = "&nbsp;";
  var tab = space + space + space + space;
  var br = "<br/>"
  var why = "CyberDojo could not rename" + br +
	 br +
	 tab + oldFilename + br +
	 "to" + br + 
	 tab + newFilename + br +
	 br +
	"because " + reason + ".";
	
  jQueryAlert(why);
}

function jQueryAlert(message)
{
  $j('<div>')
    .html(message)
    .dialog({
      autoOpen: false,
      title: "alert",
      modal: true,
      buttons: {
	ok: function() {
	  $j(this).dialog('close');
	}
      }
    })
    .dialog('open');  
}

function renameFile() 
{
  var oldFilename = currentFilename();

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
	  var newFilename = trim(input.val());
	  renameFileFromTo(oldFilename, newFilename);
	},
	cancel: function() {
	  $j(this).dialog('close');
	}
      }
    });
    
  input.keyup(function(event) {
    event.preventDefault();
    var CARRIAGE_RETURN = 13;
    if (event.keyCode == CARRIAGE_RETURN) {
      var newFilename = trim(input.val());
      renamer.dialog('close');
      renameFileFromTo(oldFilename, newFilename);
    }  
  });

  renamer.dialog('open');
}

function renameFileFromTo(oldFilename, newFilename)
{
  if (newFilename === "") {
    var message = "No filename entered" + "<br/>" +
          "Rename " + oldFilename + " abandoned";
    jQueryAlert(message);
    return;
  }
  if (newFilename === oldFilename) {
    var message = "Same filename entered." + "<br/>" +
          oldFilename + " is unchanged";
    jQueryAlert(message);
    return;
  }
  if (fileAlreadyExists(newFilename))
  {
    renameFailure(oldFilename, newFilename,
		  "a file called " + newFilename + " already exists");
    return;
  }
  if (newFilename.indexOf("/") !== -1)
  {
    renameFailure(oldFilename, newFilename,
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
  
  deleteFilePrompt(false);
  newFileContent(newFilename, content, caretPos, scrollTop, scrollLeft);

  rebuildFilenameList();
  selectFileInFileList(newFilename);
}

function createHiddenInput(filename, aspect, value)
{
  return $j("<input>", {
    type: 'hidden',
    name: 'file_' + aspect + "['" + filename + "']",
    id: 'file_' + aspect + '_for_' + filename,
    value: value
  });
}

function trim(s)
{
  return s === null ? null : s.replace(/^\s+|\s+$/g,"");
  // $j.trim(s); fails in IE8
}

function makeFileListEntry(filename) 
{
  var div = $j("<div>", {
    class: 'mid_tone filename'
  });

  div.click(function() {
    saveFile(currentFilename());
    loadFile(filename);
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
}

function allFilenames() 
{
  var prefix = 'file_content_for_';
  var filenames = [ ]
  $j('input[id^="' + prefix + '"]').each(function(index) {
    var id = $j(this).attr('id');
    var filename = id.substr(prefix.length, id.length - prefix.length);
    filenames.push(filename);
  });
  return filenames;
}

function fileAlreadyExists(filename) 
{
  return $j.inArray(filename, allFilenames()) !== -1;
}

function rand(n)
{
  return Math.floor(Math.random() * n);
}

function randomChar()
{
  var alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';
  return alphabet.charAt(rand(alphabet.length));
}

function random3() 
{
  return randomChar() + randomChar() + randomChar();
}


