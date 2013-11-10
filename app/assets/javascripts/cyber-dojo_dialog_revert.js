/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, tag, maxTag) {    
  
    var makeRevertInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
	          '<div id="traffic_light">' +
			  '</div>' +
		    '</td>' +
		    '<td>' +
			  '<img class="avatar_image"' +
				   'height="47"' +
				   'width="47"' +
				   'src="/images/avatars/' + avatarName + '.jpg">' +
		    '</td>' +
		  '</tr>' +
		'</table>';	  
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	  
	var makeNavigateButton = function(name) {	
	  return '' +
	    '<div class="triangle button"' +
			 'id="' + name + '_button">' +
		  '<img src="/images/triangle_' + name + '.gif"' +
			   'alt="move to ' + name + ' diff"' +                 
			   'width="25"' + 
			   'height="25" />' +
	    '</div>';      
	};	
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    var makeNavigateButtons = function() {
	  return '' +
	    '<div class="panel">' +
		  '<table class="align-center">' +
			'<tr>' +
			  '<td>' +
				 makeNavigateButton('first') +
			  '</td>' +
			  '<td>' +
				 makeNavigateButton('prev') +
			  '</td>' +
			  '<td>' +
				'<div id="traffic_light_number">' +			
				'</div>' +
			  '</td>' +
			  '<td>' +
				 makeNavigateButton('next') +
			  '</td>' +
			  '<td>' +
				 makeNavigateButton('last') +
			  '</td>' +
			'</tr>' +
		  '</table>' +
		'</div>';
	};			
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
    var makeReverterDiv = function()  {
      var div = $('<div>', {    
        'id': 'revert_dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr class='valign-top'>" +
          "<td>" +
			makeRevertInfo() +
          "</td>" +
          "<td rowspan='3'>" +
           "<textarea id='revert_content'" +
		             "class='file_content'" +
					 "readonly='readonly'" +
		             "wrap='off'>" +
		   "</textarea>" +
          "</td>" +
	    "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    makeNavigateButtons() +
          "</td>" +
        "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    "<div id='revert_filenames'" +
			     "class='panel'>" +
			"</div>" +
          "</td>" +
        "</tr>");
	  
      div.append(table);	   
      return div;
    };
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var data = undefined;

    var preview = makeReverterDiv();

	var deleteAllCurrentFiles = function() {
	  var newFilename;
	  $.each(cd.filenames(), function(_, filename) {
		if (filename !== 'output') {
		  cd.doDelete(filename);
		}
	  });					  
	};
	
	var copyRevertFilesToCurrentFiles = function() {
	  var filename;
	  for (filename in data.visibleFiles) {
		if (filename !== 'output') {
		  cd.newFileContent(filename, data.visibleFiles[filename]);
		}
	  }	  
	};		  

	var revertDialog = preview.dialog({	  
	  title: cd.dialogTitle(title),
	  autoOpen: false,
	  width: 1150,
	  modal: true,
	  buttons: {
		ok: function() {
		  deleteAllCurrentFiles();
		  copyRevertFilesToCurrentFiles();
		  cd.testForm().submit();
		  $(this).dialog('close');
		},
		cancel: function() {
		  $(this).dialog('close');
		}
	  }
	});
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var makeTrafficLight = function() {
	  var trafficLight = data.inc;
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	var makeTrafficLightNumber = function() {
	  var trafficLight = data.inc;
	  return '' +
	    '<div class="tag_' + trafficLight.colour + '">' +
		    '&nbsp;' + trafficLight.number + '&nbsp;' +
	    '</div>';	  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
		  
    var makeRevertFilenames = function() {
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
  
    var revertContent = $('#revert_content', preview);
	
	var currentFilename = undefined;
	
	var showCurrentFile = function() {	  
	  var found = false;
	  $('.filename', preview).each(function() {
		var filename = $(this).text();
		if (filename === currentFilename) {
		  $(this).click();
		  found = true;
		}
	  });
	  if (!found) {
		// make better choice?
		// cyber-dojo.sh is often first which is pretty boring
		$('.filename', preview)[0].click();		
	  }
	};
	
	var showContentOnFilenameClick = function() {
	  var previous = undefined;
	  $('.filename', preview).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = data.visibleFiles[filename];
		  revertContent.val(content);
		  if (previous !== undefined) {
			previous.removeClass('selected');
		  }
		  $(this).addClass('selected');
		  currentFilename = filename;
		  previous = $(this);                            
		});
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var firstButton = $('#first_button', preview);
	var prevButton  = $('#prev_button',  preview);
	var nextButton  = $('#next_button',  preview);
	var lastButton  = $('#last_button',  preview);
	  
    var resetNavigateButtonHandlers = function() {	  
	  var resetHandler = function(button, onOff, newTag) {
		button
		  .attr('disabled', onOff)
		  .unbind()
		  .click(function() {
			if (!onOff) {
			  tag = newTag;
			  refresh();
			}
		  }
		);			  		
	  };	  
  	  var minTag = 1;	  
	  var atMin = (tag === minTag);
	  var atMax = (tag === maxTag);
	  resetHandler(firstButton, atMin, minTag);
	  resetHandler(prevButton,  atMin, tag-1);
	  resetHandler(nextButton,  atMax, tag+1);
	  resetHandler(lastButton,  atMax, maxTag);
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
	var trafficLight       = $('#traffic_light', preview);
	var trafficLightNumber = $('#traffic_light_number', preview);
	var revertFilenames    = $('#revert_filenames', preview);
	
	var refresh = function() {
	  $.getJSON('/reverter/revert',
		{
		  id: id,
		  avatar: avatarName,
		  tag: tag
		},
		function(d) {
		  data = d;
		  resetNavigateButtonHandlers();
		  trafficLight.html(makeTrafficLight());
		  trafficLightNumber.html(makeTrafficLightNumber());
		  revertFilenames.html(makeRevertFilenames());
		  showContentOnFilenameClick();
          showCurrentFile();		  
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	revertDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag) {




  return cd;
})(cyberDojo || {}, $);

