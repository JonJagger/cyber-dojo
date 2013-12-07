/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_fork = function(title, id, avatarName, tag, maxTag) {    
  
  	var minTag = 1;
  
    var makeForkInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
	          '<div id="traffic_light">' +
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" id="fork_tag_number" value="" />' +			  
			'</td>' +			
		  '</tr>' +
		'</table>';	  
    };
    
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	  
    var makeForkerDiv = function()  {
      var div = $('<div>', {    
        'id': 'fork_dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr valign='top'>" +		  
          "<td valign='top'>" +
		  
		    "<table>" +
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
			      makeForkInfo() +
			    "</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  cd.makeNavigateButtons(avatarName) +
				"</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  "<div id='fork_filenames'" +
					   "class='panel'>" +
				  "</div>" +
				"</td>" +
			  "</tr>" +
			  
			"</table>" +
			
          "</td>" +
          "<td>" +
           "<textarea id='fork_content'" +
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

    var forkDiv = makeForkerDiv();
	
	var forkDialog = forkDiv.dialog({	  
	  title: cd.dialogTitle(title),
	  autoOpen: false,
	  width: 1150,
	  modal: true,
	  buttons: {
		ok: function() {
		  cd.postTo('/forker/fork', {
			id: id,
			avatar: avatarName,
			tag: tag
		  }, '_blank');		  
		  $(this).dialog('close');
		},
		cancel: function() {
		  $(this).dialog('close');
		}
	  }
	});
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var trafficLight = $('#traffic_light', forkDiv);

	var makeTrafficLight = function(trafficLight) {
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	var trafficLightNumber = $('#fork_tag_number', forkDiv);
		
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
		  	
	var forkFilenames = $('#fork_filenames', forkDiv);
		  
    var makeForkFilenames = function(visibleFiles) {
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
  
    var forkContent = $('#fork_content', forkDiv);
	
	var currentFilename = undefined;
		
	var showCurrentFile = function() {
	  var i, filename, filenames = [ ];
	  var files = $('.filename', forkDiv);
	  for (i = 0; i < files.length; i++) {
		filename = $(files[i]).text();
		if (filename === currentFilename) {
		  break;
		} else {
		  filenames.push(filename);
		}
	  }
	  if (i === files.length) {	  
	    i = cd.nonBoringFilenameIndex(filenames);
	  }
      files[i].click();		
	};
	
	var showContentOnFilenameClick = function(visibleFiles) {
	  var previous = undefined;
	  $('.filename', forkDiv).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = visibleFiles[filename];
		  forkContent.val(content);
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
	
	var firstButton = $('#first_button', forkDiv);
	var prevButton  = $('#prev_button',  forkDiv);
	var nextButton  = $('#next_button',  forkDiv);
	var lastButton  = $('#last_button',  forkDiv);
	  
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
	  
	  trafficLightNumber.unbind().keyup(function(event) { tagEdit(event); });  	  
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -	
	
	var refresh = function() {
	  $.getJSON('/reverter/revert',
		{
		  id: id,
		  avatar: avatarName,
		  tag: tag
		},
		function(data) {
		  resetNavigateButtonHandlers();
		  trafficLight.html(makeTrafficLight(data.inc));
		  trafficLightNumber.val(data.inc.number);
		  forkFilenames.html(makeForkFilenames(data.visibleFiles));
		  showContentOnFilenameClick(data.visibleFiles);
          showCurrentFile();		  
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	forkDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_fork = function(title, id, avatarName, tag, maxTag) {


  return cd;
})(cyberDojo || {}, $);

