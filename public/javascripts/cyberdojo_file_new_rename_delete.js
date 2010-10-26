
function rebuildFilenameList()
{
  var filenames = allFilenames();
  filenames.sort(function(lhs,rhs) {
	  if (lhs < rhs)
	    return -1;
	  else if (lhs > rhs)
	    return 1;
	  else
	    return 0; // Should never happen
    });

  var filename_list = $('filename_list');
  // Remove all children
  while (filename_list.childNodes.length >= 1)
  {
     filename_list.removeChild(filename_list.firstChild);
  } 

  // Add new children
  for (at = 0; at != filenames.length; at++)
  {
    filename_list.appendChild(makeFileListEntry(filenames[at]));
  }
}

//====================== NEW FILE =======================

function newFile()
{
  // Append three random chars to the end of the untitled filename.
  // This is so there is NO excuse not to rename it!
  newFileContent('untitled_' + random3(), 'Please rename me!', 0);
}

function newFileContent(filename, content, caret_pos)
{
  // Create new hidden input elements to store new file content
  // and its caret position (to save to before submitting form)
  $('visible_files_container').appendChild(createFileContentInput(filename, content));
  rebuildFilenameList();
  $('visible_files_container').appendChild(createFileCaretPosInput(filename, caret_pos));

  // Select it so you can immediately rename it
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
  rebuildFilenameList();
  
  var fcp = fileCaretPos(current_filename);
  fcp.parentNode.removeChild(fcp);

  var filenames = allFilenames();
  if (filenames.length != 0)
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
  if (newname == null) return; // Cancelled
  if (newname == "") { alert("No filename entered\n" +
                             "Rename " + current_filename + " abandoned"); return; }
  if (newname == current_filename) return; // Same name; nothing to do
  if (fileAlreadyExists(newname))
  {
    alert("CyberDojo cannot rename " + current_filename + " to " + newname + "\n" +
          "because a file called " + newname + " already exists.");
    return; // Cancelled
  }

  // OK. Now do it...
  // Rename by deleting and recreating with previous content
  var content = $('editor').value;
  var caret_pos = getLiveCaretPos();
  deleteFilePrompt(false);
  newFileContent(newname, content, caret_pos);

  rebuildFilenameList();
  refreshLineNumbering();
  selectFileInFileList(newname);
}


function refreshLineNumbering()
{
  // Ensure line-numbers repositions by removing and re-adding
  // (renaming a file can alter the filename-list panel width)
  var old = $('line_numbers');
  old.parentNode.removeChild(old);
  createTextAreaWithLineNumbers('editor', "<%=@kata.tab-%>");
  TabEntry.enable('editor');
}


function createFileContentInput(filename, content)
{
  var input = new Element('input');
  input.setAttribute('type', 'hidden');
  input.setAttribute('name', "file_content['" + filename + "']");
  input.setAttribute('id', 'file_content_for_' + filename);
  input.setAttribute('value', content);
  return input;
}


function createFileCaretPosInput(filename, caret_pos)
{
  var input = new Element('input');
  input.setAttribute('type', 'hidden');
  input.setAttribute('name', "file_caret_pos['" + filename + "']");
  input.setAttribute('id', 'file_caret_pos_for_' + filename);
  input.setAttribute('value', caret_pos);
  return input;
}


function trim(s) 
{
  return s == null ? null : s.replace(/^\s+|\s+$/g,"");
}


function makeFileListEntry(filename)
{
  var div = new Element('div', { 'class':'mid_tone filename' });
  div.onclick = function() { saveCurrentFile(); loadFile(filename); };
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
  for(at = 0; at != all.length; at++)
  {
    var att = all[at].getAttribute('id');
    var filename = att.substr(prefix.length, att.length - prefix.length);
    filenames.push(filename);
  }
  return filenames;
}

function fileAlreadyExists(filename)
{
  return allFilenames().indexOf(filename) != -1;
}

function random3() 
{
    var alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';
    var str = '';
    for (var at = 0; at != 3; at++) 
    {
        var pos = Math.floor(Math.random() * alphabet.length);
        str += alphabet.charAt(pos);
    }
    return str;
}


