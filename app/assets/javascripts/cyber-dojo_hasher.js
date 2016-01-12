/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var hashOf = function(content) {
    var hash, i;
    for (hash = 0, i = 0; i < content.length; ++i) {
      hash = (hash << 5) - hash + content.charCodeAt(i);
      hash &= hash;
    }
    return hash;
  };

  var outgoingHashContainer = function() {
    return $('#file_hashes_outgoing_container');
  };

  var incomingHashContainer = function() {
    return $('#file_hashes_incoming_container');
  };

  var storeOutgoingFileHash = function(filename) {
    var node = cd.fileContentFor(filename);
    var hash = hashOf(node.val());
    $('input[data-filename="'+filename+'"]', outgoingHashContainer()).remove();
    outgoingHashContainer().append(
      $('<input>', {
        'type': 'hidden',
        'data-filename': filename,
        'name': "file_hashes_outgoing[" + filename + "]",
        'value': hash
      })
    );
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var allFilesSameAsCurrentTrafficLight = function() {
    // Could be used to selectively enable/disable buttons
    var outgoingFilenames = cd.filenames();
    var incomingFilenames = [ ];
    $('input',incomingHashContainer()).each(function() {
      var filename = $(this).data('filename');
      incomingFilenames.push(filename);
    });
    incomingFilenames.sort();
    outgoingFilenames.sort();
    if (JSON.stringify(incomingFilenames) != JSON.stringify(outgoingFilenames)) {
      return false;
    }

    var allSame = true;
    $.each(incomingFilenames,function(_,filename) {
      var  inNode = $('input[data-filename="'+filename+'"]', incomingHashContainer());
      var outNode = $('input[data-filename="'+filename+'"]', outgoingHashContainer());
      if (filename != 'output' && inNode.attr('value') != outNode.attr('value')) {
        allSame = false;
      }
    });
    return allSame;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.storeOutgoingFileHashes = function() {
    outgoingHashContainer().empty();
    $.each(cd.filenames(), function(_,filename) {
      storeOutgoingFileHash(filename);
    });
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.storeIncomingFileHashes = function() {
    incomingHashContainer().empty();
    $.each(cd.filenames(), function(_,filename) {
      var node = cd.fileContentFor(filename);
      var content = node.val();
      var hash = hashOf(content);
      incomingHashContainer().append(
        $('<input>', {
          'type': 'hidden',
          'data-filename': filename,
          'name': "file_hashes_incoming[" + filename + "]",
          'value': hash
        })
      );
    });
  };

  return cd;
})(cyberDojo || {}, $);



