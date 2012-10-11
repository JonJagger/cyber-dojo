/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

   $cd.fileContentFor = function(filename) {
    return $cd.id('file_content_for_' + filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.fileDiv = function(filename) {
    return $cd.id(filename + '_div');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.currentFilename = function() {
    // I tried changing this to...
    //   return $j('input:radio[name=filename]:checked').val();
    // (which would remove the need for the file
    //    app/views/_current_filename.html.erb)
    // This worked on Firefox but not on Chrome.
    // The problem seems to be that in Chrome the javascript handler
    // function invoked when the radio button filename is clicked sees
    //    $j('input:radio[name=filename]:checked')
    // as having _already_ changed. Thus you cannot retrieve the
    // old filename. This matters since I need to retrieve and store
    // the scrollTop and scrollLeft positions of a file when it is
    // switched out of the editor by a call to hide().

    return $j('#current_filename').val();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.filenameAlreadyExists = function(filename) {
    // I have changed the shell filename in the exercises/ folders from
    // cyberdojo.sh (no hyphen) to cyber-dojo.sh (with a hyphen) to match
    // the cyber-dojo.com domain name. However, I still need to support old
    // sessions, particularly the ability to fork from a new session from an
    // old diff-view, e.g. the refactoring setups in
    // http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html
    // See also app/assets/javascripts/cyber-dojo-file_load.js
    // See also app/models/sandbox.rb
    var oldName = 'cyberdojo.sh';
    var newName = 'cyber-dojo.sh';
    return filename === oldName ||
           filename === newName ||
           $cd.inArray(filename, $cd.filenames()) ||
           $cd.inArray(filename, $cd.supportFilenames()) ||
           $cd.inArray(filename, $cd.hiddenFilenames());	   
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.rebuildFilenameList = function() {
    var filenameList = $j('#filename_list');
    var filenames = $cd.filenames();    
    filenameList.empty();
    filenames.sort();
    $j.each(filenames, function(n, filename) {
      var fileListEntry = $cd.makeFileListEntry(filename);
      filenameList.append(fileListEntry);
    });
    $j('input[type=radio]').hide();
    return filenames;
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
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

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.makeFileListEntry = function(filename) {
    // Creates a filename entry on the run-tests page. I can't stand
    // radio-lists that have differing length text and you have to
    // click exactly on the text rather than on the space after
    // the text when its one of the shorter texts. So this has extra
    // structure. The <input type="radio"...> entries are wrapped
    // inside a <div class="filename"> and it is to the div that the
    // click handler function is attached. This pattern repeats
    // in the language and exercise radio-lists in the create-page
    // and also in the diff-page filename list.
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
      text: filename
    }));
    return div;
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  return $cd;
})(cyberDojo || {}, $);



