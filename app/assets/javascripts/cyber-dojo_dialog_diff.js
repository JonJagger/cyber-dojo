/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_diff = function(title, id, avatarName, wasTag, nowTag, maxTag) {    
  
    var makeDiffInfo = function() {
	  return '' +
	    '<table class="align-center">' +
		  '<tr>' +
		    '<td>' +
			  '<div id="was_traffic_light">' +			
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" id="was_tag_number" value="' + wasTag + '" />' +
			'</td>' +
			'<td>' +
			  '&harr;' +
			'</td>' +
			'<td>' +
			  '<input type="text" id="now_tag_number" value="' + nowTag + '" />' +
			'</td>' +
		    '<td>' +
			  '<div id="now_traffic_light">' +			
			  '</div>' +			
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
	
    var makeDiffDiv = function()  {
      var div = $('<div>', {    
        'id': 'diff_dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr valign='top'>" +		  
          "<td valign='top'>" +
		  
		    "<table>" +
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
			      makeDiffInfo() +
			    "</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  makeNavigateButtons() +
				"</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" + 
				"<td valign='top'>" +
				  "<div id='diff_filenames'" +
					   "class='panel'>" +
				  "</div>" +
				"</td>" +
			  "</tr>" +
			  
			"</table>" +
			
          "</td>" +
          "<td>" +
           "<textarea id='diff_content'" +
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

    var diff = makeDiffDiv();

	var diffDialog = diff.dialog({	  
	  title: cd.dialogTitle(title),
	  autoOpen: false,
	  width: 1150,
	  modal: true,
	  buttons: {
		cancel: function() {
		  $(this).dialog('close');
		}
	  }
	});
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
		  
    var makeDiffFilenames = function() {
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
  
    var diffContent = $('#diff_content', diff);
	
	var currentFilename = undefined;
	
	var showCurrentFile = function() {	  
	  var found = false;
	  $('.filename', diff).each(function() {
		var filename = $(this).text();
		if (filename === currentFilename) {
		  $(this).click();
		  found = true;
		}
	  });
	  if (!found) {
		// make better choice?
		// cyber-dojo.sh is often first which is pretty boring
		$('.filename', diff)[0].click();		
	  }
	};
	
	var showContentOnFilenameClick = function() {
	  var previous = undefined;
	  $('.filename', diff).each(function() {
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

	var firstButton = $('#first_button', diff);
	var prevButton  = $('#prev_button',  diff);
	var nextButton  = $('#next_button',  diff);
	var lastButton  = $('#last_button',  diff);
	  
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
	
  	var makeTrafficLight = function(trafficLight) {
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var data = undefined;
	// data.wasTrafficLight
	// data.nowTrafficLight
	// data.diffs
	// data.idsAndSectionCounts
	// data.currentFilenameId

	var wasTrafficLight       = $('#was_traffic_light', diff);
	var nowTrafficLight       = $('#now_traffic_light', diff);

	var diffFilenames      = $('#diff_filenames', diff);
	
	var refresh = function() {
	  $.getJSON('/differ/diff',
		{
		  id: id,
		  avatar: avatarName,
		  was_tag: wasTag,
		  now_tag: nowTag
		},
		function(d) {
		  data = d;
		  //resetNavigateButtonHandlers();
		  wasTrafficLight.html(makeTrafficLight(data.wasTrafficLight));
		  nowTrafficLight.html(makeTrafficLight(data.nowTrafficLight));		  
		  //diffFilenames.html(makeDiffFilenames());
		  //showContentOnFilenameClick();
          //showCurrentFile();		  
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	diffDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_diff = function(title, id, avatarName, wasTag, nowTag, maxTag) {


  return cd;
})(cyberDojo || {}, $);

