/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, t) {    
  
	var tag = t;
	var data = undefined;
	var preview = undefined;
	
	var self = cd.dialog_revert;
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    self.runTests = function() {
      var form = cd.testForm();
      var action = form.attr('action');
      var revert_action = action + '&revert_tag=' + tag;
      form.attr('action', revert_action);
      form.submit();
      form.attr('action', action);    
    };
  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
    self.makeRevertInfo = function() {
	  var tag = data.inc;
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
      return div;  
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
			  self.makeRevertFilenames().html() +
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
		  $('#filenames', preview).html(self.makeRevertFilenames().html());
		  $('#traffic_light_number', preview).html(self.makeTrafficLightNumber());
		  self.showContentOnFilenameClick();			
		  $('.filename', preview)[0].click();			 
		}
	  );		
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	  
    self.setupNavigateButtonHandlers = function() {	  
	  $('#prev_button', preview).click(function() {
		tag -= 1;
		self.refresh();
	  });		
	  $('#next_button', preview).click(function() {
		tag += 1;
		self.refresh();
	  });
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
	  for (newFilename in data.visibleFiles) {
		if (newFilename !== 'output') {
		  cd.newFileContent(newFilename, data.visibleFiles[newFilename]);
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
			  self.runTests();
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
	
  }; // cd.dialog_revert = function(title, id, avatarName, t) {

  return cd;
})(cyberDojo || {}, $);

