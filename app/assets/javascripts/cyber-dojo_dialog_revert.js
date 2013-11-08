/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, t) {    
  
	var tag = t;
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

	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
			  avatarImage +
		    '</td>' +
		    '<td>' +
			  trafficLight +
		    '</td>' +
		  '</tr>' +
		'</table>';	  
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    self.revertTagFilenames = function(visibleFiles) {
      var div = $('<div>');
	  var filenames = [ ];
      var filename;
      for (filename in visibleFiles) {
        filenames.push(filename);
      }
      filenames.sort();
      $.each(filenames, function(_, filename) {
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
  
	self.navigateButton = function(name) {	
	  return '<div class="triangle button"' +
			  'id="' + name + '_button">' +
		'<img src="/images/triangle_' + name + '.gif"' +
			 'alt="move to ' + name + ' diff"' +                 
			 'width="25"' + 
			 'height="25" />' +
	  '</div>';      
	};	
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    self.navigateButtons = function(tag) {
	  return '<div class="panel">' +
	    '<table class="align-center">' +
          '<tr>' +
            '<td>' +
               self.navigateButton('first') +
			'</td>' +
			'<td>' +
               self.navigateButton('prev') +
			'</td>' +
			'<td>' +
			  '<span class="tag_' + tag.colour + '">' +
				'&nbsp;' + tag.number + '&nbsp;' +
			  '</span>' +
			'</td>' +
            '<td>' +
               self.navigateButton('next') +
			'</td>' +
			'<td>' +
               self.navigateButton('last') +
			'</td>' +
		  '</tr>' +
		'</table>' +
	  '</div>';
	};			
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
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
          "<td rowspan='3'>" +
           "<textarea id='revert_content' wrap='off'></textarea>" +
          "</td>" +
	    "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    self.navigateButtons(data.inc) +
          "</td>" +
        "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    "<div id='filenames' class='panel'>" +
			  self.revertTagFilenames(visibleFiles).html() +
			"</div>" +
          "</td>" +
        "</tr>");
	  
      div.append(table);
	   
	  var textArea = $('#revert_content', div);
	  textArea.attr('readonly', 'readonly');
	  textArea.addClass('file_content');

      return div;
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
	self.showContentOnFilenameClick = function(visibleFiles, preview) {
	  var textArea = $('#revert_content', preview);
	  var previous = undefined;
	  $('.filename', preview).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = visibleFiles[filename];
		  textArea.val(content);
		  if (previous !== undefined) {
			previous.removeClass('selected');
		  }
		  $(this).addClass('selected');
		  previous = $(this);                            
		});
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    self.setupNavigateButtonHandlers = function(preview) {
	  
	  var refresh = function() {
		$.getJSON('/reverter/revert',
		  {
			id: id,
			avatar: avatarName,
			tag: tag
		  },
		  function(data) {
			$('#filenames', preview).html(
  	         self.revertTagFilenames(data.visibleFiles).html()
			);
	        self.showContentOnFilenameClick(data.visibleFiles, preview);			
    	    $('.filename', preview)[0].click();			 
		  }
		);		
	  };
	  
	  $('#prev_button', preview).click(function() {
		tag -= 1;
		refresh();
	  });
		
	  $('#next_button', preview).click(function() {
		tag += 1;
		refresh();
	  });
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
	self.createRevertDialog = function(data) {
	  var preview = self.reverterDiv(data);
	  self.showContentOnFilenameClick(data.visibleFiles, preview);
	  $('.filename', preview)[0].click();	  
	  self.setupNavigateButtonHandlers(preview);
	  
	  return preview.dialog({
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

