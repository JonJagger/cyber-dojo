/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.fileContentFor = function(filename) {
    return cd.id('file_content_for_' + filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.fileDiv = function(filename) {
    return cd.id(filename + '_div');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.currentFilename = function() {
    // I tried changing this to...
    //   return $('input:radio[name=filename]:checked').val();
    // (which would remove the need for the file
    //    app/views/_current_filename.html.erb)
    // This worked on Firefox but not on Chrome.
    // The problem seems to be that in Chrome the javascript handler
    // function invoked when the radio button filename is clicked sees
    //    $('input:radio[name=filename]:checked')
    // as having _already_ changed. Thus you cannot retrieve the
    // old filename. This matters since I need to retrieve and store
    // the scrollTop and scrollLeft positions of a file when it is
    // switched out of the editor by a call to hide().

    return $('#current_filename').val();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.filenameAlreadyExists = function(filename) {
    return filename === 'cyber-dojo.sh' ||
           cd.inArray(filename, cd.filenames()) ||
           cd.inArray(filename, cd.supportFilenames()) ||
           cd.inArray(filename, cd.hiddenFilenames());	   
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.rebuildFilenameList = function() {
    var filenameList = $('#filename_list');
    var filenames = cd.filenames();    
    filenameList.empty();
    filenames.sort();
    $.each(filenames, function(n, filename) {
      var fileListEntry = cd.makeFileListEntry(filename);
      filenameList.append(fileListEntry);
    });
    $('input[type=radio]').hide();
    return filenames;
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.filenames = function() {  
    var prefix = 'file_content_for_';
    var filenames = [ ];
    $('textarea[id^="' + prefix + '"]').each(function(index) {
      var id = $(this).attr('id');
      var filename = id.substr(prefix.length, id.length - prefix.length);
      filenames.push(filename);
    });
    return filenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeFileListEntry = function(filename) {
    // Creates a filename entry on the run-tests page. I can't stand
    // radio-lists that have differing length text and you have to
    // click exactly on the text rather than on the space after
    // the text when its one of the shorter texts. So this has extra
    // structure. The <input type="radio"...> entries are wrapped
    // inside a <div class="filename"> and it is to the div that the
    // click handler function is attached. This pattern repeats
    // in the language and exercise radio-lists in the setup-page
    // and also in the diff-page filename list.
    var div = $('<div>', {
      'class': 'filename'
    });
    div.click(function() {
      cd.loadFile(filename);
    });
    div.append($('<input>', {
      id: 'radio_' + filename,
      name: 'filename',
      type: 'radio',
      value: filename   
    }));
    div.append($('<label>', {
      text: filename
    }));
    return div;
  };
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeNewFile = function(filename, content) {
    var div = $('<div>', {
      'class': 'filename_div',
      name: filename,
      id: filename + '_div'
    });
    var table = $('<table>', {
      cellspacing: '0',
      cellpadding: '0'
    });
    var tr = $('<tr>');
    var td1 = $('<td>');
    var lines = $('<textarea>', {
      'class': 'line_numbers',
      id: filename + '_line_numbers'
    });
    var td2 = $('<td>');
    var text = $('<textarea>', {
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
    cd.bindHotKeys(text);
    cd.tabber(text);
    return div;
  };

  return cd;
})(cyberDojo || {}, $);



