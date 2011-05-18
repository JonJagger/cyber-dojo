
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

  var filename_list = $('filename_list');
  // Remove all children
  while (filename_list.childNodes.length >= 1) 
  {
     filename_list.removeChild(filename_list.firstChild);
  } 

  // Add new children
  for (var at = 0; at < filenames.length; at++) 
  {
    filename_list.appendChild(makeFileListEntry(filenames[at]));
  }
}

//====================== NEW FILE =======================

function newFile() 
{
  // Append three random chars to the end of the untitled filename.
  // This is so there is NO excuse not to rename it!
  newFileContent('untitled_' + random3(), 'Please rename me!', 0, 0, 0);
}

function newFileContent(filename, content, caret_pos, scroll_top, scroll_left) 
{
  // Create new hidden input elements to store new file content
  // and its caret and scroll positions (to save to before submitting form)
  $('visible_files_container').appendChild(
    createHiddenInput(filename, 'content', content));
  $('visible_files_container').appendChild(
    createHiddenInput(filename, 'caret_pos', caret_pos));
  $('visible_files_container').appendChild(
    createHiddenInput(filename, 'scroll_top', scroll_top));
  $('visible_files_container').appendChild(
    createHiddenInput(filename, 'scroll_left', scroll_left));

  rebuildFilenameList();
  // Select it so you can immediately rename it
  saveCurrentFile();
  loadFile(filename);
}

//====================== DELETE FILE =======================

function deleteFile() 
{
  deleteFilePrompt(true);
}

function deleteFilePrompt(ask) 
{
  if (!current_filename) return;
  if (ask && !confirm("Delete " + current_filename)) return; // Cancelled  

  var fc = fileContent(current_filename);
  fc.parentNode.removeChild(fc);
  
  var fcp = fileCaretPos(current_filename);
  fcp.parentNode.removeChild(fcp);
  
  var fst = fileScrollTop(current_filename);
  fst.parentNode.removeChild(fst);
  
  var fsl = fileScrollLeft(current_filename);
  fsl.parentNode.removeChild(fsl);

  rebuildFilenameList();
  var filenames = allFilenames();
  if (filenames.length !== 0) 
  {
    loadFile(filenames[0]);
    refreshLineNumbering();
  } 
  else 
  {
    current_filename = false;
    $('editor').value = '';
  }
}

//====================== RENAME FILE =======================

function renameFile() 
{
  if (!current_filename) return;

  var newname = trim(prompt("Rename " + current_filename + " ?", 
                            "was_" + current_filename));
  if (newname === null) return; // Cancelled
  if (newname === "") { alert("No filename entered\n" +
                             "Rename " + current_filename + " abandoned"); return; }
  if (newname === current_filename) return; // Same name; nothing to do
  if (fileAlreadyExists(newname))
  {
    alert("CyberDojo cannot rename " + current_filename + " to " + newname + "\n" +
          "because a file called " + newname + " already exists.");
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
  newFileContent(newname, content, caret_pos, scroll_top, scroll_left);

  rebuildFilenameList();
  refreshLineNumbering();
  selectFileInFileList(newname);
}


function refreshLineNumbering() 
{
  // Ensure line-numbers repositions by removing and re-adding
  // (renaming a file can alter the filename-list panel width)
  var old = $('editor_line_numbers');
  old.parentNode.removeChild(old);
  createLineNumbersForEditor();
}

function createHiddenInput(filename, aspect, value)
{
  var input = new Element('input');
  input.setAttribute('type', 'hidden');
  input.setAttribute('name', 'file_' + aspect + "['" + filename + "']");
  input.setAttribute('id', 'file_' + aspect + '_for_' + filename);
  input.setAttribute('value', value);
  return input;
}

function trim(s)  // TODO: jQuery has a trim function $.trim(s) 
{
  return s === null ? null : s.replace(/^\s+|\s+$/g,"");
}

function makeFileListEntry(filename) 
{
  var div = new Element('div', { 'class':'mid_tone filename' });
  div.onclick = function() { 
    saveCurrentFile();
    loadFile(filename);
  };
  var inp = new Element('input', 
    { id:'radio_' + filename, 
      name:'filename', 
      type:'radio', 
      value:filename 
    });
  div.appendChild(inp);
  div.appendChild(document.createTextNode(filename));
  return div;
}

function allFilenames() 
{
  var prefix = 'file_content_for_';
  filenames = []
  var all = $$('input[id^="' + prefix + '"]');
  for(var at = 0; at < all.length; at++) 
  {
    var att = all[at].getAttribute('id');
    var filename = att.substr(prefix.length, att.length - prefix.length);
    filenames.push(filename);
  }
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
    for (var at = 0; at < 3; at++) 
    {
        var pos = Math.floor(Math.random() * alphabet.length);
        str += alphabet.charAt(pos);
    }
    return str;
}


