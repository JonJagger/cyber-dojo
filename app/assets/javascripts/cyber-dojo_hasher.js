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
    $('input[data-filename="'+filename+'"]',outgoingHashContainer()).remove();    
    outgoingHashContainer().append(
      $('<input>', {
        'type': 'hidden',
        'data-filename': filename,
        'name': "file_hashes_outgoing[" + filename + "]",
        'value': hash
      })
    );
  };
  
  var allFilesSameAsCurrentTrafficLight = function() {
    var outgoingFilenames = cd.filenames();
    var incomingFilenames = [ ];    
    $('input',incomingHashContainer()).each(function() {
      var filename = $(this).data('filename');
      incomingFilenames.push(filename);
    });    
    incomingFilenames.sort();
    outgoingFilenames.sort();    
    if (JSON.stringify(incomingFilenames) != JSON.stringify(outgoingFilenames)) {
      //alert("incomingFilenames != outgoingFilenames");
      return false;
    }

    //var msg = "\n";
    var allSame = true;
    $.each(incomingFilenames,function(_,filename) {
      var  inNode = $('input[data-filename="'+filename+'"]', incomingHashContainer());
      var outNode = $('input[data-filename="'+filename+'"]', outgoingHashContainer());
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
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.setForkAndTestButtons = function() {
    var same = allFilesSameAsCurrentTrafficLight();
    $('#fork_button').attr('disabled', !same);
    // I could do this...
    //   $('#test').attr('disabled', same);
    // so the test button is only enabled when the file contents
    // is in some way different to the previous traffic-light.
    // Trouble with this is that a new players initial
    // view will be of a disabled test button.
    $('#test').attr('disabled', false);
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
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  cd.setContentListeners = function() {    
    $(".file_content").unbind().on("keyup", function() {      
      var filename = $(this).data('filename');
      storeOutgoingFileHash(filename);
      cd.setForkAndTestButtons();
    });    
  };
    
  return cd;
})(cyberDojo || {}, $);



