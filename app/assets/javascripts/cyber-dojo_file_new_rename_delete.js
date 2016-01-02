/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var makeInput = function(name, filename) {
    var input = $('<input>', {
      type: 'text',
      id: name+'-filename',
      'name': name+'-filename',
      value: filename
    });
    if (name == 'delete') {
      input.attr('disabled', 'disabled');
    }
    return input;
  };

  // - - - - - - - - - - - - -

  var openDialog = function(title, okDisabled, okClicked, input, avatar) {
    var ok = {
      text: 'ok',
      id: 'file-ok',
      disabled: okDisabled(),
      click: function() {
        okClicked();
        $(this).remove();
      }
    };
    var cancel = {
      text: 'cancel',
      click: function() { $(this).remove(); }
    };
    var img = $('<img>', {
        'src': '/images/avatars/' + avatar + '.jpg',
      'style': 'width:214px'
    });
    var div = $('<div>');
    div.append(input);
    div.append(img);
    var dialog = div.dialog({
      closeOnEscape: true,
      close: function() { $(this).remove(); },
  	  title: cd.dialogTitle(title + '&nbsp;' + 'file'),
    	autoOpen: false,
      width: 250,
  	  modal: true,
      buttons: [ ok, cancel ]
    });

  	input.keyup(function(event) {
      var ok = $('#file-ok');
      var newFilename = $.trim(input.val());
      event.preventDefault();
      if (cd.isValidFilename(newFilename))  {
        ok.button('enable');
        if (event.keyCode == $.ui.keyCode.ENTER) {
          okClicked();
          ok.closest('.ui-dialog').remove();
        }
      } else {
        ok.button('disable');
      }
    });

    dialog.dialog('open');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // delete file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(avatar) {
    var filename = cd.currentFilename();
    var input = makeInput('delete', filename);
    var okClicked = function() { cd.doDelete(filename); };
    var okInitiallyDisabled = function() { return false; };
    openDialog('delete', okInitiallyDisabled, okClicked, input, avatar);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // new file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFile = function(avatar) {
    var newFilename = 'filename' + cd.extensionFilename();
    var input = makeInput('new', newFilename);
    var okInitiallyDisabled = function() { return !cd.isValidFilename(newFilename); };
    var okClicked = function() {
      var newFilename = $.trim(input.val());
      cd.newFileContent(newFilename, '');
    };
    openDialog('new', okInitiallyDisabled, okClicked, input, avatar);
    input[0].setSelectionRange(0, newFilename.length);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // rename file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(avatar) {
    var oldFilename = cd.currentFilename();
    var input = makeInput('rename', oldFilename);
    var okInitiallyDisabled = function() { return !cd.isValidFilename(oldFilename); };
    var okClicked = function() {
      var newFilename = $.trim(input.val());
      cd.renameFileFromTo(oldFilename, newFilename);
    };
    openDialog('rename', okInitiallyDisabled, okClicked, input, avatar);

    var end = oldFilename.lastIndexOf('.');
    if (end == -1) {
      end = oldFilename.length;
    }
    input[0].setSelectionRange(0, end);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.renameFileFromTo = function(oldFilename, newFilename) {
    var oldFile = cd.fileContentFor(oldFilename);
    var content = oldFile.val();
    var scrollTop = oldFile.scrollTop();
    var scrollLeft = oldFile.scrollLeft();
    var caretPos = oldFile.caret();
    $(oldFile).closest('tr').remove();

    cd.newFileContent(newFilename, content);
    cd.rebuildFilenameList();
    cd.loadFile(newFilename);
    var newFile = cd.fileContentFor(newFilename);
    // Note that doing the seemingly equivalent
    //   fc.scrollTop(top);
    //   fc.scrollLeft(left);
    // here does _not_ work. I use animate instead with a
    // very fast duration==1 and that does work!
    newFile.animate({scrollTop:scrollTop, scrollLeft:scrollLeft}, 1);
    newFile.caret(caretPos);
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  cd.isValidFilename = function(filename) {
    var contains = function(illegal) { return filename.indexOf(illegal) != -1; };
    if (cd.filenameAlreadyExists(filename)) { return false; }
    if (contains('..')) { return false; }
    if (contains('\\')) { return false; }
    if (contains('/'))  { return false; }
    if (contains(' '))  { return false; }
    if (filename == '') { return false; }
    return true;
  };

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
  // These two functions are also used in the
  // revert functionality in app/views/review/_review.html.erb

  cd.newFileContent = function(filename, content) {
    var newFile = cd.makeNewFile(filename, content);
    $('#visible-files-container').append(newFile);
    cd.bindLineNumbers(filename);
    cd.rebuildFilenameList();
    cd.loadFile(filename);
  };

  cd.doDelete = function(filename) {
    cd.fileDiv(filename).remove();
    var filenames = cd.rebuildFilenameList();
    var i = cd.nonBoringFilenameIndex(filenames);
    cd.loadFile(filenames[i]);
  };

  return cd;

})(cyberDojo || {}, $);
