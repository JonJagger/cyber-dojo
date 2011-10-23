
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
  if (tests_running)
    return;
  
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
  if (current_filename === 'output') return;
  if (current_filename === 'cyberdojo.sh') return;
  
  if (ask && !confirm("Delete " + current_filename + " ?")) return; // Cancelled

  fileContent(current_filename).remove();  
  fileCaretPos(current_filename).remove();
  fileScrollTop(current_filename).remove();  
  fileScrollLeft(current_filename).remove();

  rebuildFilenameList();
  var filenames = allFilenames();
  // output cannot be deleted so always at least one file
  loadFile(filenames[0]);
  refreshLineNumbering();
}

function renameFailure(current_filename, new_filename, because)
{
  alert("CyberDojo cannot rename\n" +
	 "\n" +
	 "    " + current_filename + "\n" +
	 "to\n" + 
	 "    " + new_filename + "\n" +
	 "\n" +
	"because " + because + ".");  
}

function renameFile() 
{
  if (!current_filename) return;
  if (current_filename === 'output') return;
  if (current_filename === 'cyberdojo.sh') return;

  var new_filename = prompt("Rename " + current_filename + " ?", 
                            "was_" + current_filename);
  var new_filename = trim(new_filename);
  if (new_filename === null) return; // Cancelled
  if (new_filename === "") { alert("No filename entered\n" +
                             "Rename " + current_filename + " abandoned"); return; }
  if (new_filename === current_filename) return; // Same name; nothing to do
  if (fileAlreadyExists(new_filename))
  {
    renameFailure(current_filename, new_filename,
		  "a file called " + new_filename + " already exists");
    return; // Cancelled
  }
  if (new_filename.indexOf("/") !== -1)
  {
    renameFailure(current_filename, new_filename,
		  new_filename + " contains a forward slash");
    return; // Cancelled
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
  refreshLineNumbering();
  selectFileInFileList(new_filename);
}

function refreshLineNumbering() 
{
  // Ensure line-numbers repositions by removing and re-adding
  // (renaming a file can alter the filename-list panel width)
  $j('#editor_line_numbers').remove();
  createLineNumbersForEditor();
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
  return allFilenames().indexOf(filename) !== -1;
}

function random3() 
{
  var alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';
  var str = '';
  $j.map([1,2,3], function() {
      var pos = Math.floor(Math.random() * alphabet.length);
      str += alphabet.charAt(pos);    
  });
  return str;
}


