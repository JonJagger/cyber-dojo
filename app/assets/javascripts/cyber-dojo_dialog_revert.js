/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, tag) {    

	var self = cd.dialog_revert;
	
    self.runTestsWithRevertTag = function() {
      var form = cd.testForm();
      var action = form.attr('action');
      var revert_action = action + '&revert_tag=' + tag;
      form.attr('action', revert_action);
      form.submit();
      form.attr('action', action);    
    };
  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
    self.revertTagInfo = function(tag) {
      var colour = tag.colour;
      var avatarImage =
        '<img ' +
          'class="avatar_image"' +
          'height="47"' +
          'width="47"' +
          'src="/images/avatars/' + avatarName + '.jpg">';
      var filename = 'traffic_light_' + colour;
      if (tag.revert_tag !== null) {
        filename += '_revert';
      }
      var trafficLight = 
        "<img src='/images/" + filename + ".png'" +
        " width='15'" +
        " height='46'/>";

	  var trafficLightNumber =	  
		'<span class="tag_' + colour + '">' +
		  '&nbsp;' + tag.number + '&nbsp;' +
		'</span>';
	  
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
			  avatarImage +
		    '</td>' +
		    '<td>' +
			  trafficLight +
		    '</td>' +
		    '<td>' +
			  trafficLightNumber +
		    '</td>' +
		  '</tr>' +
		'</table>';	  
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    self.revertTagFilenames = function(visibleFiles) {
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
          'class': 'filename',
          'id': 'radio_' + filename,
          'text': filename
        });
        div.append(f);
      });
      return div;
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
	cd.navigateButton = function(name) {	
	  return "<div class='triangle button'" +
			  'id="' + name + '_button">' +
		'<img src="/images/triangle_' + name + '.gif"' +
			 'alt="move to ' + name + ' diff"' +                 
			 'width="25"' + 
			 'height="25" />' +
	  '</div>';      
	};	
	
    cd.navigateButtons = function(tag) {
	  return '<div class="panel">' +
	    '<table class="align-center">' +
          '<tr>' +
            '<td>' +
               cd.navigateButton('first') +
			'</td>' +
			'<td>' +
               cd.navigateButton('prev') +
			'</td>' +
			'<td>' +
			  '<span class="tag_' + tag.colour + '">' +
				'&nbsp;' + tag.number + '&nbsp;' +
			  '</span>' +
			'</td>' +
            '<td>' +
               cd.navigateButton('next') +
			'</td>' +
			'<td>' +
               cd.navigateButton('last') +
			'</td>' +
		  '</tr>' +
		'</table>' +
	  '</div>';
	};			
	
    self.reverterDiv = function(data)  {
      var visibleFiles = data.visibleFiles;
      var color = data.inc.colour;
      var number = data.inc.number;
      var div = $('<div>', {    
        'id': 'revert_dialog'
      });

      var table = $('<table>');
      table.append(
        "<tr class='valign-top'>" +
          "<td>" +
			self.revertTagInfo(data.inc) +
          "</td>" +
          "<td rowspan='2'>" + //3
           "<textarea id='revert_content' wrap='off'></textarea>" +
          "</td>" +
	    "</tr>" +
		//"<tr class='valign-top'>" + 
        //  "<td>" +
		//    cd.navigateButtons(data.inc) +
        //  "</td>" +
        //"</tr>" +
		"<tr class='valign-top'>" + 
         "<td><div class='panel'>" +
			self.revertTagFilenames(visibleFiles).html() +
         "</td>" +
       "</div></tr>");
       div.append(table);
       return div;
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	

    self.previewHtml = function(data) {
	  var preview = self.reverterDiv(data);
	  var textArea = $('#revert_content', preview);
	  var previous = undefined;
	  textArea.attr('readonly', 'readonly');
	  textArea.addClass('file_content');
	  $('.filename', preview).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = data.visibleFiles[filename];
		  textArea.val(content);
		  if (previous !== undefined) {
			previous.removeClass('selected');
		  }
		  $(this).addClass('selected');
		  previous = $(this);                            
		});
	  });
	  $('.filename', preview)[0].click();
	  return preview;
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
	self.createRevertDialog = function(data) {
	  return self.previewHtml(data).dialog({
		  title: cd.dialogTitle(title),
		  autoOpen: false,
		  width: 950,
		  modal: true,
		  buttons: {
			ok: function() {
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
			  self.runTestsWithRevertTag();
			  $(this).dialog('close');
			}, // revert: ... {
			cancel: function() {
			  $(this).dialog('close');
			} // cancel: ... {
		  } // buttons: {
		}); // self.previewHtml(data).dialog({
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    $.getJSON('/reverter/revert',
      {
        id: id,
        avatar: avatarName,
        tag: tag
      },
	  function(data) {
		self.createRevertDialog(data).dialog('open');		
	  }
    );
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag) {

  return cd;
})(cyberDojo || {}, $);

