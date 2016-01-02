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

  var openDialog = function(name, initialFilename, okInitiallyDisabled, okClicked, avatar) {
    var input = makeInput(name, initialFilename);
    var ok = {
      text: 'ok',
      id: 'file-ok',
      disabled: okInitiallyDisabled,
      click: function() {
        var newFilename = $.trim(input.val());
        okClicked(newFilename);
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
  	  title: cd.dialogTitle(name + '&nbsp;' + 'file'),
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
          okClicked(newFilename);
          ok.closest('.ui-dialog').remove();
        }
      } else {
        ok.button('disable');
      }
    });

    var end = initialFilename.lastIndexOf('.');
    if (end == -1) {
      end = initialFilename.length;
    }
    input[0].setSelectionRange(0, end);

    dialog.dialog('open');
  };


  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // delete file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(avatar) {
    var initialFilename = cd.currentFilename();
    var okInitiallyDisabled = false;
    var okClicked = function(filename) { cd.doDelete(filename); };
    openDialog('delete', initialFilename, okInitiallyDisabled, okClicked, avatar);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // new file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFile = function(avatar) {
    var initialFilename = 'filename' + cd.extensionFilename();
    var okInitiallyDisabled = !cd.isValidFilename(initialFilename);
    var okClicked = function(newFilename) { cd.newFileContent(newFilename, ''); };
    openDialog('new', initialFilename, okInitiallyDisabled, okClicked, avatar);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // rename file
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.renameFile = function(avatar) {
    var oldFilename = cd.currentFilename();
    var okInitiallyDisabled = true;
    var okClicked = function(newFilename) { cd.renameFileFromTo(oldFilename, newFilename); };
    openDialog('rename', oldFilename, okInitiallyDisabled, okClicked, avatar);
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
