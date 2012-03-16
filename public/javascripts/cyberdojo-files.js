
var cyberDojo = (function($cd, $j) {
  
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
    return $cd.inArray(filename, $cd.filenames()) ||
           $cd.inArray(filename, $cd.support_filenames()) ||
           $cd.inArray(filename, $cd.hidden_filenames());	   
  };
    
  $cd.inArray = function(find, array) {
    return $j.inArray(find, array) !== -1;    
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

  return $cd;
})(cyberDojo || {}, $j);



