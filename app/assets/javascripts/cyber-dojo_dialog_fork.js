/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_fork = function(title, cancel, id, avatarName, tag, maxTag, forkButton) {
    // There is a lot commonality in the fork and revert dialogs.
	// And both could be improved by showing the red/green
	// lines added/removed (like on the diff)

  	var minTag = 1;

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var makeForkInfo = function() {
	  return '' +
	    '<table id="revert-fork-info">' +
		  '<tr>' +
			'<td>' +
			  '<img height="38"' +
			      ' width="38"' +
			      ' src="/images/avatars/' + avatarName + '.jpg"/>' +
			'</td>' +
		  '</tr>' +
		'</table>';
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var makeForkTagControl = function() {
	  return '' +
	    '<table id="revert-fork-tag-control">' +
		  '<tr>' +
			'<td>' +
			  '<button type="button"' +
			          'id="revert-fork-button">' +
				  title +
			  '</button>' +
			'</td>' +
		    '<td>' +
	          '<div id="traffic-light">' +
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" id="revert-fork-tag-number" value="" />' +
			'</td>' +
		  '</tr>' +
		'</table>';
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var makeForkerDiv = function()  {
      var div = $('<div>', {
        'id': 'revert-fork-dialog'
      });
	  var hr = '' +
		'<tr>' +
		  '<td>' +
			'<hr/>' +
		  '</td>' +
		'</tr>';
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
			  hr +
			  "<tr valign='top'>" +
				"<td valign='top'>" +
			      makeForkTagControl() +
			    "</td>" +
			  "</tr>" +
			  hr +
			  "<tr valign='top'>" +
				"<td valign='top'>" +
				  cd.makeNavigateButtons() +
				"</td>" +
			  "</tr>" +
			  hr +
			  "<tr valign='top'>" +
				"<td valign='top'>" +
				  "<div id='revert-fork-filenames'>" +
				  "</div>" +
				"</td>" +
			  "</tr>" +

			"</table>" +

          "</td>" +
          "<td>" +
           "<textarea id='revert-fork-content'" +
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
	  autoOpen: false,
	  width: 1100,
	  height: "auto",
	  modal: true,
	  buttons: [
		{
		  text: cancel,
		  click: function() {
		    $(this).remove();
		  }
	    }
	  ]
	});

	$('#revert-fork-button', forkDiv).click(function() {
	  $.getJSON('/forker/fork', {
		id: id,
		avatar: avatarName,
		tag: tag
	  }, function(data) {
		if (data.forked) {
		  // important not to do window.open(url) directly from here
		  // as it will open in a new window and not a new tab ***
		  forkSucceededDialog(data);
		} else {
		  forkFailedDialog(data);
		}
	  });
	  forkDialog.remove();
	});

	var forkSucceededDialog = function(fork) {
	  var html = "" +
	    "<div class='dialog'>" +
		  "<div class='panel' style='font-size:1.5em;'>" +
	        "your forked dojo's id is" +
			"<div class='align-center'>" +
              "<span class='kata-id-input'>" +
			  "&nbsp;" +
			  fork.id.substring(0,6) +
			  "&nbsp;" +
			  "</span>" +
			"</div>" +
		  "</div>" +
		"</div>";
	  var succeeded = $('<div>').html(html).dialog({
		autoOpen: false,
		modal: true,
		width: 450,
		buttons: {
		  ok: function() {
			// *** whereas here it will open in a new tab
			var url = '/dojo/index/' + fork.id;
			window.open(url);
			$(this).remove();
		  }
		}
	  });
	  succeeded.dialog('open');
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var forkFailedDialog = function(data) {
	  var diagnostic = " an unknown failure occurred";
	  if (data.reason === 'id') {
		diagnostic = "the practice session no longer exists";
	  } else if (data.reason === 'language') {
		diagnostic = "the language " + data['language'] + " no longer exists";
	  } else if (data.reason === 'avatar') {
		diagnostic = "there is no " + avatarName +
		             " in the practice session";
	  } else  if (data.reason === 'tag') {
		diagnostic = avatarName +
		            " doesn't have traffic-light[" + tag + "]" +
		            " in the practice session";
	  }
	  var html = "" +
	    "<div class='dialog'>" +
		  "<div class='panel' style='font-size:1em;'>" +
	        "On the originating server " + diagnostic + "."
		  "</div>" +
		"</div>";
	  var failed = $('<div>').html(html).dialog({
		title: cd.dialogTitle('could not fork'),
		autoOpen: false,
		modal: true,
		width: 450,
		buttons: {
		  ok: function() {
			$(this).remove();
		  }
		}
	  });
	  failed.dialog('open');
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var trafficLight = $('#traffic-light', forkDiv);

	var makeTrafficLight = function(trafficLight) {
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var trafficLightNumber = $('#revert-fork-tag-number', forkDiv);

	var tagEdit = function(event) {
	  if (event.keyCode === $.ui.keyCode.ENTER) {
		var newTag = parseInt(trafficLightNumber.val(), 10);
		if (isNaN(newTag) || newTag < minTag || newTag > maxTag) {
		  trafficLightNumber.val(tag);
		} else {
		  tag = newTag;
		  forkButton = $(event.target); // wait-cursor hack
		  refresh();
		}
	  }
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var forkFilenames = $('#revert-fork-filenames', forkDiv);

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

    var forkContent = $('#revert-fork-content', forkDiv);

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
			  forkButton = $(this); // wait-cursor hack
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

	var refresh = function(open) {
	  var cursor = forkButton.css('cursor');
      forkButton.css('cursor', 'wait');
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
		  if (open !== undefined) {
			open();
		  }
		}
	  ).always(function() {
        forkButton.css('cursor', cursor);
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	refresh(function() {
	  // only open after all html-loaded otherwise
	  // dialog may not center on the page.
	  forkDialog.dialog('open');
	});

  }; // cd.dialog_fork = function(title, close, id, avatarName, tag, maxTag) {


  return cd;
})(cyberDojo || {}, $);
