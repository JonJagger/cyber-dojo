/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, close, id, avatarName, tag, maxTag) {    
    // This is virtually identical to
	// cyber-dojo_dialog_fork.js
	// except for the command executed when ok is pressed
	// and refresh().
  	var minTag = 1;
  
    var makeRevertInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
			'<td>' +
			  '<button type="button"' +
			          'id="revert_button">' +
				  title +
			  '</button>' +
			'</td>' +
		    '<td>' +
	          '<div id="traffic_light">' +
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" ' +
			        ' id="revert_tag_number"' +
					' value="" />' +			  
			'</td>' +
		  '</tr>' +
		'</table>';	  
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
				  cd.makeNavigateButtons(avatarName) +
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

	$('#revert_button', revertDiv).click(function() {
	  deleteAllCurrentFiles();
	  copyRevertFilesToCurrentFiles();
	  cd.testForm().submit();
	  revertDialog.remove();
	});

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
	  autoOpen: false,
	  width: 1200,
	  modal: true,
	  buttons: [
		{
		  text: close,
		  click: function() {
			$(this).remove();
		  }
	    }
	  ]
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
	  var i, filename, filenames = [ ];
	  var files = $('.filename', revertDiv);
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

