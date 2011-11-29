
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
  // This is so there is NO excuse not to rename it!
  newFileContent('newfile_' + random3(), 'Please rename me!', 0, 0, 0);
}

function newFileContent(filename, content, caretPos, scrollTop, scrollLeft) 
{
  // Create new hidden input elements to store new file content
  // and its caret and scroll positions (to save to before submitting form)
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'content', content));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'caret_pos', caretPos));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'scroll_top', scrollTop));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'scroll_left', scrollLeft));

  rebuildFilenameList();
  // Select it so you can immediately rename it
  saveCurrentFile();
  loadFile(filename);
}

function deleteFile() 
{
  deleteFilePrompt(true);
}

function deleteFilePrompt(ask) 
{
  if (!current_filename) return;
  if (current_filename === 'cyberdojo.sh') return;
  
  var deleter =
    $j("<div>")
      .html(current_filename)
      .dialog({
	autoOpen: false,
	title: "delete file",
	modal: true,
	buttons: {
	  ok: function() {
	    doDelete();
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
    doDelete();
}

function doDelete()
{
  fileContent(current_filename).remove();  
  fileCaretPos(current_filename).remove();
  fileScrollTop(current_filename).remove();  
  fileScrollLeft(current_filename).remove();

  rebuildFilenameList();
  var filenames = allFilenames();
  // cyberdojo.sh cannot be deleted so always at least one file
  loadFile(filenames[0]);
}

function renameFailure(currentFilename, newFilename, reason)
{
  var space = "&nbsp;";
  var tab = space + space + space + space;
  var br = "<br/>"
  var why = "CyberDojo could not rename" + br +
	 br +
	 tab + currentFilename + br +
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
  if (!current_filename) return;
  if (current_filename === 'cyberdojo.sh') return;

  var input = $j('<input>', {
    type: 'text',
    id: 'renamer',
    name: 'renamer',
    value: "was_" + current_filename
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
	  renameFileTo(newFilename);
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
      renameFileTo(newFilename);
    }  
  });

  renamer.dialog('open');
}

function renameFileTo(newFilename)
{
  if (newFilename === "") {
    var message = "No filename entered" + "<br/>" +
          "Rename " + current_filename + " abandoned";
    jQueryAlert(message);
    return;
  }
  if (newFilename === current_filename) {
    var message = "Same filename entered" + "<br/>" +
          "Rename " + current_filename + " abandoned";
    jQueryAlert(message);
    return;
  }
  if (fileAlreadyExists(newFilename))
  {
    renameFailure(current_filename, newFilename,
		  "a file called " + newFilename + " already exists");
    return;
  }
  if (newFilename.indexOf("/") !== -1)
  {
    renameFailure(current_filename, newFilename,
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
    // Important to make Editor tab visible to ensure caretPos() works properly.
    // See http://stackoverflow.com/questions/1516297/how-to-hide-wmd-editor-initially
    saveCurrentFile();
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


