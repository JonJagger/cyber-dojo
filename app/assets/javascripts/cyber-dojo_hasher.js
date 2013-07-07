/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  cd.hashOf = function(content) {
    var hash, i;
    for (hash = 0, i = 0; i < content.length; ++i) {
      hash = (hash << 5) - hash + content.charCodeAt(i);
      hash &= hash;
    }
    return hash;
  };  
  
  cd.storeIncomingFileHashes = function() {
    var container = $('#file_hashes_incoming_container');
    container.empty();
    $.each(cd.filenames(), function(index,filename) {
      var node = cd.fileContentFor(filename);
      var content = node.val();
      var hash = cd.hashOf(content);
      container.append(
        $('<input>', {
          'type': 'hidden',
          'name': "file_hashes_incoming[" + filename + "]",
          'value': hash
        })
      );
    });
  };

  cd.storeOutgoingFileHashes = function() {
    var container = $('#file_hashes_outgoing_container');
    container.empty();
    $.each(cd.filenames(), function(index,filename) {
      var node = cd.fileContentFor(filename);
      var content = node.val();
      var hash = cd.hashOf(content);
      container.append(
        $('<input>', {
          'type': 'hidden',
          'name': "file_hashes_outgoing[" + filename + "]",
          'value': hash
        })
      );
    });    
  };
    
  return cd;
})(cyberDojo || {}, $);



