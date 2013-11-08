/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, tag, maxTag) {    
  
	var minTag = 1;
	var data = undefined;
	var preview = undefined;
	
	var self = cd.dialog_revert;
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
	self.makeTrafficLight = function() {
	  var trafficLight = data.inc;
      var filename = 'traffic_light_' + trafficLight.colour;
      if (trafficLight.revert_tag !== null) {
        filename += '_revert';
      }
      return '' +
	    "<div id='traffic_light'>" +
		  "<img src='/images/" + filename + ".png'" +
		  " width='15'" +
		  " height='46'/>" +
		"</div>";		  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    self.makeRevertInfo = function() {
	  var trafficLight = data.inc;
      var avatarImage =
        '<img ' +
          'class="avatar_image"' +
          'height="47"' +
          'width="47"' +
          'src="/images/avatars/' + avatarName + '.jpg">';

	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
			  avatarImage +
		    '</td>' +
		    '<td>' +
			  self.makeTrafficLight() +
		    '</td>' +
		  '</tr>' +
		'</table>';	  
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
	
	self.makeTrafficLightNumber = function() {
	  var trafficLight = data.inc;
	  return '' +
		'<div id="traffic_light_number" class="tag_' + trafficLight.colour + '">' +
		  '&nbsp;' + trafficLight.number + '&nbsp;' +
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
               self.makeTrafficLightNumber() +
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
			  self.makeRevertFilenames() +
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
	  
    self.setupNavigateButtonHandlers = function() {
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
	
	self.makeRevertDialog = function() {
	  return preview.dialog({
		  title: cd.dialogTitle(title),
		  autoOpen: false,
		  width: 950,
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
	
    $.getJSON('/reverter/revert',
      {
        id: id,
        avatar: avatarName,
        tag: tag
      },
	  function(d) {		
		data = d;
	    preview = self.reverterDiv();
		self.showContentOnFilenameClick();
		$('.filename', preview)[0].click();	  
		self.setupNavigateButtonHandlers();
		self.makeRevertDialog().dialog('open');		
	  }
    );
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag) {

  return cd;
})(cyberDojo || {}, $);

