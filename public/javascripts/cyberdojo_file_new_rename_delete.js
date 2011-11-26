
function sortFilenames(filenames) 
{
  filenames.sort(function(lhs,rhs) 
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
  $j.each(filenames, function(n,filename) {
    filename_list.append(makeFileListEntry(filename));
  });
}

function newFile() 
{
  // Append three random chars to the end of the filename.
  // This is so there is NO excuse not to rename it!
  newFileContent('newfile_' + random3(), 'Please rename me!', 0, 0, 0);
}

function newFileContent(filename, content, caret_pos, scroll_top, scroll_left) 
{
  // Create new hidden input elements to store new file content
  // and its caret and scroll positions (to save to before submitting form)
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'content', content));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'caret_pos', caret_pos));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'scroll_top', scroll_top));
  $j('#visible_files_container').append(
    createHiddenInput(filename, 'scroll_left', scroll_left));

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
	title: "Delete?",
	modal: true,
	buttons: {
	  Delete: function() {
	    doDelete();
	    $j(this).dialog('close');
	  },
	  Cancel: function() {
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

function renameFailure(current_filename, new_filename, reason)
{
  var space = "&nbsp;";
  var tab = space + space + space + space;
  var br = "<br/>"
  var why = "CyberDojo could not rename" + br +
	 br +
	 tab + current_filename + br +
	 "to" + br + 
	 tab + new_filename + br +
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
      title: "Alert!",
      modal: true,
      buttons: {
	Ok: function() {
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
      title: "Rename to...",
      modal: true,
      buttons: {
	Ok: function() {
	  $j(this).dialog('close');
	  var new_filename = trim(input.val());
	  renameFileTo(new_filename);
	},
	Cancel: function() {
	  $j(this).dialog('close');
	}
      }
    });
    
  input.keyup(function(event) {
    event.preventDefault();
    if (event.keyCode == 13) {
      var new_filename = trim(input.val());
      renamer.dialog('close');
      renameFileTo(new_filename);
    }  
  });

  renamer.dialog('open');
}

function renameFileTo(new_filename)
{
  if (new_filename === "") {
    var message = "No filename entered" + "<br/>" +
          "Rename " + current_filename + " abandoned";
    jQueryAlert(message);
    return;
  }
  if (new_filename === current_filename) {
    var message = "Same filename entered" + "<br/>" +
          "Rename " + current_filename + " abandoned";
    jQueryAlert(message);
    return;
  }
  if (fileAlreadyExists(new_filename))
  {
    renameFailure(current_filename, new_filename,
		  "a file called " + new_filename + " already exists");
    return;
  }
  if (new_filename.indexOf("/") !== -1)
  {
    renameFailure(current_filename, new_filename,
		  new_filename + " contains a forward slash");
    return;
  }
  
  // OK. Now do it...
  // Rename by deleting and recreating with previous content
  
  var editor = $j('#editor');
  var content = editor.val();
  var caret_pos = editor.caretPos();
  var scroll_top = editor.scrollTop();
  var scroll_left = editor.scrollLeft();
  
  deleteFilePrompt(false);
  newFileContent(new_filename, content, caret_pos, scroll_top, scroll_left);

  rebuildFilenameList();
  selectFileInFileList(new_filename);
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
  filenames = [ ]
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


