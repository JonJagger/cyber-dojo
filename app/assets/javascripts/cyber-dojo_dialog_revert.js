/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(id, avatarName, tag) {    

    cd.dialog_revert.runTestsWithRevertTag = function() {
      var form = $('#test').closest("form");
      var action = form.attr('action');
      var revert_action = action + '&revert_tag=' + tag;
      form.attr('action', revert_action);
      form.submit();
      form.attr('action', action);    
    };
  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
    cd.dialog_revert.info = function(data) {
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
        " height='62'/>";
      var trafficLightNumber =     
        '<span class="tag_count">' +
          data.inc.number +
        '</span>';
      return cd.makeTable(avatarImage, trafficLight, trafficLightNumber);
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    cd.dialog_revert.reverterFilenames = function(visibleFiles) {
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
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    cd.dialog_revert.reverterDiv = function(data)  {
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
           cd.dialog_revert.info(data) +
           cd.dialog_revert.reverterFilenames(visibleFiles).html() +
         "</td>" +
         "<td>" +
           "<textarea id='revert_content' wrap='off'></textarea>" +
         "</td>" +
       "</tr>");
       div.append(table);
       return div;
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	

    cd.dialog_revert.callBack = function(data) {
	  var preview = cd.dialog_revert.reverterDiv(data);
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
	  
	  return preview.dialog({
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
			  cd.dialog_revert.runTestsWithRevertTag();                  
			  $(this).dialog('close');
			}, // revert: ... {
			cancel: function() {
			  $(this).dialog('close');
			} // cancel: ... {
		  } // buttons: {
		}); // var reverter = preview.dialog({
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    $.getJSON('/reverter/revert',
      {
        id: id,
        avatar: avatarName,
        tag: tag
      },
	  function(data) {
		var reverter = cd.dialog_revert.callBack(data);
	    reverter.dialog('open');		
	  }
    );
	
  }; // cd.dialog_revert = function(id, avatarName, tag) {

  return cd;
})(cyberDojo || {}, $);

