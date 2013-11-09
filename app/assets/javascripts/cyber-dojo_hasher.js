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
    $.each(cd.filenames(), function(_,filename) {
      var node = cd.fileContentFor(filename);
      var content = node.val();
      var hash = cd.hashOf(content);
      container.append(
        $('<input>', {
          'type': 'hidden',
          'data-filename': filename,
          'name': "file_hashes_incoming[" + filename + "]",
          'value': hash
        })
      );
    });
  };

  cd.storeOutgoingFileHash = function(filename) {
    var container = $('#file_hashes_outgoing_container');
    var node = cd.fileContentFor(filename);
    var hash = cd.hashOf(node.val());    
    $('input[data-filename="'+filename+'"]',container).remove();    
    container.append(
      $('<input>', {
        'type': 'hidden',
        'data-filename': filename,
        'name': "file_hashes_outgoing[" + filename + "]",
        'value': hash
      })
    );
  };
  
  cd.storeOutgoingFileHashes = function() {
    var container = $('#file_hashes_outgoing_container');
    container.empty();
    $.each(cd.filenames(), function(_,filename) {
      cd.storeOutgoingFileHash(filename);
    });    
  };
    
  cd.allFilesSameAsCurrentTrafficLight = function() {
    var  inHashes = $('#file_hashes_incoming_container');
    var incomingFilenames = [ ];
    $('input',inHashes).each(function() {
      var filename = $(this).data('filename');
      incomingFilenames.push(filename);
    });
        
    var outgoingFilenames = cd.filenames();
    
    incomingFilenames.sort();
    outgoingFilenames.sort();
    
    if (JSON.stringify(incomingFilenames) != JSON.stringify(outgoingFilenames)) {
      //alert("incomingFilenames != outgoingFilenames");
      return false;
    }

    var outHashes = $('#file_hashes_outgoing_container');
    //var msg = "\n";
    var allSame = true;
    $.each(incomingFilenames,function(i,filename) {
      var  inNode = $('input[data-filename="'+filename+'"]',  inHashes);
      var outNode = $('input[data-filename="'+filename+'"]', outHashes);
      if (filename != 'output' && inNode.attr('value') != outNode.attr('value')) {
        allSame = false;
      }
      //msg += filename + ": in:" +  inNode.attr('value') + "\n";
      //msg += filename + ":out:" + outNode.attr('value') + "\n";
    });
    //msg += "returning " + allSame;
    //alert(msg);
    return allSame;
  };
  
  cd.setForkButton = function() {
    if (cd.allFilesSameAsCurrentTrafficLight()) {
      $('#fork_button').removeAttr('disabled');
      $('#test').attr('disabled', true);
    } else {
      $('#fork_button').attr('disabled', true);
      $('#test').attr('disabled',false);
    }    
  };
  
  cd.setContentListeners = function() {    
    $(".file_content").unbind().on("keyup", function() {      
      var filename = $(this).data('filename');
      cd.storeOutgoingFileHash(filename);
      cd.setForkButton();
    });    
  };
    
  return cd;
})(cyberDojo || {}, $);



