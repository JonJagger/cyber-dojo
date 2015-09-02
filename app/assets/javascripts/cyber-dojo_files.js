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
    // old filename. 
    return $('#current-filename').val();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.filenameAlreadyExists = function(filename) {
    return cd.inArray(filename, cd.filenames());
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.rebuildFilenameList = function() {
    var filenameList = $('#filename-list');
    var filenames = cd.filenames();
    // output first
    filenames.splice(filenames.indexOf('output'), 1);
    filenameList.empty();
    filenameList.append(cd.makeFileListEntry('output'));
    filenames.sort();
    // then highlight filenames
    $.each(filenames, function(_, filename) {
      if (!cd.inArray(filename, cd.lowlightFilenames())) {
        var fileListEntry = cd.makeFileListEntry(filename);
        filenameList.append(fileListEntry);
      }
    });
    // then lowlight filenames
    $.each(filenames, function(_, filename) {
      if (cd.inArray(filename, cd.lowlightFilenames())) {
        var fileListEntry = cd.makeFileListEntry(filename);
        filenameList.append(fileListEntry);
      }
    });
    return filenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.filenames = function() {
    var prefix = 'file_content_for_';
    var filenames = [ ];
    $('textarea[id^=' + prefix + ']').each(function(_) {
      var id = $(this).attr('id');
      var filename = id.substr(prefix.length, id.length - prefix.length);
      filenames.push(filename);
    });
    return filenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeFileListEntry = function(filename) {
    var div = $('<div>', {
      'class': 'filename',
      id: 'radio_' + filename,
      text: filename
    });
    if (cd.inArray(filename, cd.highlightFilenames())) {
      div.addClass('highlight');
    }
    if (cd.inArray(filename, cd.lowlightFilenames())) {
      div.addClass('lowlight');
    }
    div.click(function() { cd.loadFile(filename); });
    return div;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeNewFile = function(filename, content) {
    var div = $('<div>', {
      'class': 'filename_div',
      id: filename + '_div'
    });
    var table = $('<table>');
    var tr = $('<tr>');
    var td1 = $('<td>');
    var lines = $('<div>', {
      'class': 'line_numbers',
      id: filename + '_line_numbers'
    });
    var td2 = $('<td>');
    var text = $('<textarea>', {
      'class': 'file_content',
      'spellcheck': 'false',
      'data-filename': filename,
      name: 'file_content[' + filename + ']',
      id: 'file_content_for_' + filename
      //
      //wrap: 'off'
      //
    });
    // For some reason, setting wrap cannot be done as per the
    // commented out line above... when you create a new file in
    // FireFox 17.0.1 it still wraps at the textarea width. 
    // So instead I do it like this, which works in FireFox?!
    text.attr('wrap', 'off');

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

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.nonBoringFilenameIndex = function(filenames) {
    // In << < > >> navigation the current file is
    // sometimes not present after the navigation
    // (eg the file has been renamed/deleted).
    // When this happens, try to select a non-boring file.
    var i, filename;
    for (i = 0; i < filenames.length; i++) {
      filename = filenames[i];
      if (filename !== 'cyber-dojo.sh' &&
          filename !== 'instructions' &&
          filename != 'output') {
        break;
      }
    }
    // This could select a filename whose content is empty
    // Ideally I'd look at the content too.
    // And possibly also look at the file that changed the most.
    if (i === filenames.length) {
      i = 0;
    }
    return i;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return cd;
})(cyberDojo || {}, $);
