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
	  
	var makeNavigateButton = function(name) {	
	  return '<div class="triangle button"' +
			  'id="' + name + '_button">' +
		'<img src="/images/triangle_' + name + '.gif"' +
			 'alt="move to ' + name + ' diff"' +                 
			 'width="25"' + 
			 'height="25" />' +
	  '</div>';      
	};	
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
    var makeNavigateButtons = function() {
	  return '<div class="panel">' +
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
           "<textarea id='revert_content' wrap='off'></textarea>" +
          "</td>" +
	    "</tr>" +
		"<tr class='valign-top'>" + 
          "<td>" +
		    makeNavigateButtons() +
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
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var preview = makeReverterDiv();

	var data = undefined;

	var revertDialog = preview.dialog({	  
	  title: cd.dialogTitle(title),
	  autoOpen: false,
	  width: 1150,
	  modal: true,
	  buttons: {
		ok: function() {		  
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
		" width='15'" +
		" height='46'/>";
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
  
	var showContentOnFilenameClick = function() {
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
	  
    var setupNavigateButtonHandlers = function() {
  	  var minTag = 1;	  
	  var firstPrev = (tag > minTag);
	  var nextLast  = (tag < maxTag);
	  
	  $('#first_button', preview)
		.attr('disabled', !firstPrev)
	    .unbind()
		.click(function() {
		  if (firstPrev) {
			tag = minTag;
			refresh();
		  }
	    }
	  );			  
	  $('#prev_button',  preview)
		.attr('disabled', !firstPrev)
		.unbind()
		.click(function() {
		  if (firstPrev) {
			tag -= 1;
			refresh();
		  }
		}
	  );	  
	  $('#next_button', preview)
		.attr('disabled', !nextLast)
		.unbind()
		.click(function() {
		  if (nextLast) {
			tag += 1;
			refresh();
		  }
	    }
	  );
	  $('#last_button', preview)
		.attr('disabled', !nextLast)
		.unbind()
		.click(function() {
		  if (nextLast) {
			tag = maxTag;
			refresh();
		  }
	    }
	  );			  
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
		  $('#filenames', preview).html(makeRevertFilenames());
		  $('#traffic_light', preview).html(makeTrafficLight());
		  $('#traffic_light_number', preview).html(makeTrafficLightNumber());
		  setupNavigateButtonHandlers();
		  showContentOnFilenameClick();			
		  $('.filename', preview)[0].click();			 
		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	revertDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_revert = function(title, id, avatarName, tag) {

  return cd;
})(cyberDojo || {}, $);

