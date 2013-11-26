/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, id, avatarName, tag, maxTag) {    
  
  	var minTag = 0;
  
    var makeRevertInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
	          '<div id="traffic_light">' +
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" id="revert_tag_number" value="" />' +			  
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
				'<img class="avatar_image"' +
					 'height="47"' +
					 'width="47"' +
					 'src="/images/avatars/' + avatarName + '.jpg">' +
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
        "<tr valign='top'>" +		  
          "<td valign='top'>" +
		  
		    "<table>" +
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
			      makeRevertInfo() +
			    "</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  makeNavigateButtons() +
				"</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  "<div id='revert_filenames'" +
					   "class='panel'>" +
				  "</div>" +
				"</td>" +
			  "</tr>" +
			  
			"</table>" +
			
          "</td>" +
          "<td>" +
           "<textarea id='revert_content'" +
		             "class='file_content'" +
					 "readonly='readonly'" +
		             "wrap='off'>" +
		   "</textarea>" +
          "</td>" +
	    "</tr>");
	  
      div.append(table);	   
      return div;
    };
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var revertDiv = makeReverterDiv();

	var deleteAllCurrentFiles = function() {
	  var newFilename;
	  $.each(cd.filenames(), function(_, filename) {
		if (filename !== 'output') {
		  cd.doDelete(filename);
		}
	  });					  
	};
	
	var data = undefined;
	
	var copyRevertFilesToCurrentFiles = function() {
	  var filename;
	  for (filename in data.visibleFiles) {
		if (filename !== 'output') {
		  cd.newFileContent(filename, data.visibleFiles[filename]);
		}
	  }	  
	};		  

	var revertDialog = revertDiv.dialog({	  
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

	var trafficLight = $('#traffic_light', revertDiv);

	var makeTrafficLight = function(trafficLight) {
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	var trafficLightNumber = $('#revert_tag_number', revertDiv);
		
	var tagEdit = function(event) {
	  if (event.keyCode === $.ui.keyCode.ENTER) {
		var newTag = parseInt(trafficLightNumber.val(), 10);
		if (isNaN(newTag) || newTag < minTag || newTag > maxTag) {
		  trafficLightNumber.val(tag);
		} else {
		  tag = newTag;
		  refresh();		
		}
	  }        
	};
		
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
		  	
	var revertFilenames = $('#revert_filenames', revertDiv);
		  
    var makeRevertFilenames = function(visibleFiles) {
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
      return div.html();
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
  
    var revertContent = $('#revert_content', revertDiv);
	
	var currentFilename = undefined;
	
	var showCurrentFile = function() {	  
	  var found = false;
	  $('.filename', revertDiv).each(function() {
		var filename = $(this).text();
		if (filename === currentFilename) {
		  $(this).click();
		  found = true;
		}
	  });
	  if (!found) {
		// TODO: make better choice
		// cyber-dojo.sh is often first which is pretty boring
		$('.filename', revertDiv)[0].click();		
	  }
	};
	
	var showContentOnFilenameClick = function(visibleFiles) {
	  var previous = undefined;
	  $('.filename', revertDiv).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = visibleFiles[filename];
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
	
	var firstButton = $('#first_button', revertDiv);
	var prevButton  = $('#prev_button',  revertDiv);
	var nextButton  = $('#next_button',  revertDiv);
	var lastButton  = $('#last_button',  revertDiv);
	  
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
	  var atMin = (tag === minTag);
	  var atMax = (tag === maxTag);
	  resetHandler(firstButton, atMin, minTag);
	  resetHandler(prevButton,  atMin, tag-1);
	  resetHandler(nextButton,  atMax, tag+1);
	  resetHandler(lastButton,  atMax, maxTag);
	  
	  trafficLightNumber.unbind('keyup').keyup(function(event) { tagEdit(event); });  	  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
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
		  trafficLight.html(makeTrafficLight(data.inc));
		  trafficLightNumber.val(data.inc.number);
		  revertFilenames.html(makeRevertFilenames(data.visibleFiles));
		  showContentOnFilenameClick(data.visibleFiles);
          showCurrentFile();		  
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	revertDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag, maxTag) {


  return cd;
})(cyberDojo || {}, $);

