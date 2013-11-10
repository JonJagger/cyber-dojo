/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, tag, maxTag) {    
  
	var self = cd.dialog_revert;
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
    self.makeRevertInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
	          '<div id="traffic_light">' +
			  '</div>' +
		    '</td>' +
		    '<td>' +
			  '<img ' +
				'class="avatar_image"' +
				'height="47"' +
				'width="47"' +
				'src="/images/avatars/' + avatarName + '.jpg">' +
		    '</td>' +
		  '</tr>' +
		'</table>';	  
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	  
	self.makeNavigateButton = function(name) {	
	  return '<div class="triangle button"' +
			  'id="' + name + '_button">' +
		'<img src="/images/triangle_' + name + '.gif"' +
			 'alt="move to ' + name + ' diff"' +                 
			 'width="25"' + 
			 'height="25" />' +
	  '</div>';      
	};	
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    self.makeNavigateButtons = function() {
	  return '<div class="panel">' +
	    '<table class="align-center">' +
          '<tr>' +
            '<td>' +
               self.makeNavigateButton('first') +
			'</td>' +
			'<td>' +
               self.makeNavigateButton('prev') +
			'</td>' +
			'<td>' +
    	      '<div id="traffic_light_number">' +			
			  '</div>' +
			'</td>' +
            '<td>' +
               self.makeNavigateButton('next') +
			'</td>' +
			'<td>' +
               self.makeNavigateButton('last') +
			'</td>' +
		  '</tr>' +
		'</table>' +
	  '</div>';
	};			
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    self.reverterDiv = function()  {
      var div = $('<div>', {    
        'id': 'revert_dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr class='valign-top'>" +
          "<td>" +
			self.makeRevertInfo() +
          "</td>" +
          "<td rowspan='3'>" +
           "<textarea id='revert_content' wrap='off'></textarea>" +
          "</td>" +
	    "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    self.makeNavigateButtons() +
          "</td>" +
        "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    "<div id='filenames' class='panel'>" +
			"</div>" +
          "</td>" +
        "</tr>");
	  
      div.append(table);	   
	  var textArea = $('#revert_content', div);
	  textArea.attr('readonly', 'readonly');
	  textArea.addClass('file_content');
      return div;
    };

	self.makeRevertDialog = function() {
	  return preview.dialog({
		  title: cd.dialogTitle(title),
		  autoOpen: false,
		  width: 1150,
		  modal: true,
		  buttons: {
			ok: function() {
			  self.deleteAllCurrentFiles();
			  self.copyRevertFilesToCurrentFiles();
			  cd.testForm().submit();			  
			  $(this).dialog('close');
			},
			cancel: function() {
			  $(this).dialog('close');
			}
		  }
		});
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var preview = self.reverterDiv();

	var revertDialog = preview.dialog({
	  title: cd.dialogTitle(title),
	  autoOpen: false,
	  width: 1150,
	  modal: true,
	  buttons: {
		ok: function() {
		  self.deleteAllCurrentFiles();
		  self.copyRevertFilesToCurrentFiles();
		  cd.testForm().submit();			  
		  $(this).dialog('close');
		},
		cancel: function() {
		  $(this).dialog('close');
		}
	  }
	});
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var data = undefined;
	
	self.makeTrafficLight = function() {
	  var trafficLight = data.inc;
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		" width='15'" +
		" height='46'/>";
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	self.makeTrafficLightNumber = function() {
	  var trafficLight = data.inc;
	  return '' +
	    '<div class="tag_' + trafficLight.colour + '">' +
		    '&nbsp;' + trafficLight.number + '&nbsp;' +
	    '</div>';	  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
		  
    self.makeRevertFilenames = function() {
      var div = $('<div>');
	  var filenames = [ ];
      var filename;
      for (filename in data.visibleFiles) {
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
      return div.html();
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
	self.showContentOnFilenameClick = function() {
	  var textArea = $('#revert_content', preview);
	  var previous = undefined;
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
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	  
    self.setupNavigateButtonHandlers = function() {
  	  var minTag = 1;	  
	  var firstPrev = (tag > minTag);
	  var nextLast  = (tag < maxTag);
	  
	  $('#first_button', preview)
		.attr('disabled', !firstPrev)
	    .unbind()
		.click(function() {
		  if (firstPrev) {
			tag = minTag;
			self.refresh();
		  }
	    }
	  );			  
	  $('#prev_button',  preview)
		.attr('disabled', !firstPrev)
		.unbind()
		.click(function() {
		  if (firstPrev) {
			tag -= 1;
			self.refresh();
		  }
		}
	  );	  
	  $('#next_button', preview)
		.attr('disabled', !nextLast)
		.unbind()
		.click(function() {
		  if (nextLast) {
			tag += 1;
			self.refresh();
		  }
	    }
	  );
	  $('#last_button', preview)
		.attr('disabled', !nextLast)
		.unbind()
		.click(function() {
		  if (nextLast) {
			tag = maxTag;
			self.refresh();
		  }
	    }
	  );			  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	

	self.deleteAllCurrentFiles = function() {
	  var newFilename;
	  $.each(cd.filenames(), function(_, filename) {
		if (filename !== 'output') {
		  cd.doDelete(filename);
		}
	  });					  
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	

	self.copyRevertFilesToCurrentFiles = function() {
	  var filename;
	  for (filename in data.visibleFiles) {
		if (filename !== 'output') {
		  cd.newFileContent(filename, data.visibleFiles[filename]);
		}
	  }	  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	self.refresh = function() {
	  $.getJSON('/reverter/revert',
		{
		  id: id,
		  avatar: avatarName,
		  tag: tag
		},
		function(d) {
		  data = d;
		  $('#filenames', preview).html(self.makeRevertFilenames());
		  $('#traffic_light', preview).html(self.makeTrafficLight());
		  $('#traffic_light_number', preview).html(self.makeTrafficLightNumber());
		  self.setupNavigateButtonHandlers();
		  self.showContentOnFilenameClick();			
		  $('.filename', preview)[0].click();			 
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	revertDialog.dialog('open');
	self.refresh();
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag) {

  return cd;
})(cyberDojo || {}, $);

