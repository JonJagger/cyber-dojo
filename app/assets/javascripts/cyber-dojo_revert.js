/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.revert = function(id, avatarName, tag) {    

    var runTestsWithRevertTag = function() {
      var form = $('#test').closest("form");
      var action = form.attr('action');
      var revert_action = action + '&revert_tag=' + tag;
      form.attr('action', revert_action);
      form.submit();
      form.attr('action', action);    
    }; // runTestsWithRevertTag()
  
    var info = function(data) {
      var color = data.inc.colour;
      var avatarImage =
        '<img ' +
          'class="avatar_image"' +
          'height="47"' +
          'width="47"' +
          'src="/images/avatars/' + avatarName + '.jpg">';
      var filename = 'traffic_light_' + color;
      if (data.inc.revert_tag !== null) {
        filename += '_revert';
      }
      var trafficLight = 
        "<img src='/images/" + filename + ".png'" +
        " border='0'" +
        " width='20'" +
        " height='65'/>";
      var trafficLightNumber =     
        '<span class="tag_count">' +
          data.inc.number +
        '</span>';
      return cd.makeTable(avatarImage, trafficLight, trafficLightNumber);
    }; // info()
    
    var reverterDiv = function(data)  {
      var visibleFiles = data.visibleFiles;
      var color = data.inc.colour;
      var number = data.inc.number;
      var div = $('<div>', {    
        'id': 'revert_dialog'
      });    
      var table = $('<table>');
      table.append(
       "<tr valign='top'>" +
         "<td>" +
           info(data) +
           reverterFilenames(visibleFiles).html() +
         "</td>" +
         "<td>" +
           "<textarea id='revert_content' wrap='off'></textarea>" +
         "</td>" +
       "</tr>");
       div.append(table);
       return div;
    }; // reverterDiv()
    
    var reverterFilenames = function(visibleFiles) {
      var div = $('<div>', {
        'class': 'panel'
      });
      var filename, filenames = [ ];
      for (filename in visibleFiles) {
        filenames.push(filename);
      }
      filenames.sort();
      $.each(filenames, function(n, filename) {
        var f = $('<div>', {
          'class': 'filename'
        });
        f.append($('<input>', {
          id: 'radio_' + filename,
          name: 'filename',
          type: 'radio',
          value: filename   
        }));
        f.append($('<label>', {
          text: filename
        }));
        div.append(f);
      });
      return div;
    }; // reverterFilename()

    $.getJSON('/reverter/revert',
      {
        id: id,
        avatar: avatarName,
        tag: tag
      },
      function(data) {        
        var preview = reverterDiv(data);
        var textArea = $('#revert_content', preview);
        var previous = undefined;
        textArea.attr('readonly', 'readonly');
        textArea.addClass('file_content');
        $('.filename', preview).each(function() {
          $(this).click(function() {
            var filename = $('input', $(this)).attr('value');
            var content = data.visibleFiles[filename];
            textArea.val(content);
            if (previous !== undefined) {
              previous.removeClass('selected');
            }
            $(this).addClass('selected');
            previous = $(this);                            
          });
        });
        $('input[type=radio]', preview).hide();
        $('.filename', preview)[0].click();
        
        var reverter = 
          preview.dialog({
            title: cd.dialogTitle('revert?'),
            autoOpen: false,
            width: 950,
            modal: true,
            buttons: {
              revert: function() {
				var newFilename;
                $.each(cd.filenames(), function(n, filename) {
				  if (filename !== 'output') {
					cd.doDelete(filename);
				  }
                });				
                for (newFilename in data.visibleFiles) {
				  if (newFilename !== 'output') {
                    cd.newFileContent(newFilename, data.visibleFiles[newFilename]);
				  }
                }
                runTestsWithRevertTag();                  
                $(this).dialog('close');
              }, // revert
              cancel: function() {
                $(this).dialog('close');
              } // cancel
            } // buttons
          }); // preview.dialog({
        reverter.dialog('open');
      } // function(data) {
    ); // $.getJSON(
  }; // cd.revert = function(...) {

  return cd;
})(cyberDojo || {}, $);

