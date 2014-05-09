/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_revert = function(title, cancel, id, avatarName, tag, maxTag, revertButton) {
	// Refactor this so it can both revert and fork?
  	var minTag = 1;

    var makeInfo = function() {
	  return '' +
	    '<table class="align-center">' +
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
			  '<input type="text" ' +
			        ' id="revert-fork-tag-number"' +
					' value="" />' +
			'</td>' +
			'<td>' +
			  '<img height="38"' +
			      ' width="38"' +
			      ' src="/images/avatars/' + avatarName + '.jpg"/>' +
			'</td>' +
		  '</tr>' +
		'</table>';
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var makeRevertForkDiv = function()  {
      var div = $('<div>', {
        'id': 'revert-fork-dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr valign='top'>" +
          "<td valign='top'>" +

		    "<table>" +
			  "<tr valign='top'>" +
				"<td valign='top'>" +
			      makeInfo() +
			    "</td>" +
			  "</tr>" +

			  "<tr valign='top'>" +
				"<td valign='top'>" +
				  cd.makeNavigateButtons(avatarName) +
				"</td>" +
			  "</tr>" +

			  "<tr valign='top'>" +
				"<td valign='top'>" +
				  "<div id='revert-fork-filenames'" +
					   "class='panel'>" +
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

    var revertForkDiv = makeRevertForkDiv();

	$('#revert-fork-button', revertForkDiv).click(function() {
	  deleteAllCurrentFiles();
	  copyRevertFilesToCurrentFiles();
	  cd.testForm().submit();
	  revertForkDialog.remove();
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

	var revertForkDialog = revertForkDiv.dialog({
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

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var trafficLight = $('#traffic-light', revertForkDiv);

	var makeTrafficLight = function(trafficLight) {
      var filename = 'traffic_light_' + trafficLight.colour;
      return '' +
		"<img src='/images/" + filename + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var trafficLightNumber = $('#revert-fork-tag-number', revertForkDiv);

	var tagEdit = function(event) {
	  if (event.keyCode === $.ui.keyCode.ENTER) {
		var newTag = parseInt(trafficLightNumber.val(), 10);
		if (isNaN(newTag) || newTag < minTag || newTag > maxTag) {
		  trafficLightNumber.val(tag);
		} else {
		  tag = newTag;
		  revertButton = $(event.target); // wait-cursor hack
		  refresh();
		}
	  }
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var revertForkFilenames = $('#revert-fork-filenames', revertForkDiv);

    var makeRevertForkFilenames = function(visibleFiles) {
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

    var revertForkContent = $('#revert-fork-content', revertForkDiv);

	var currentFilename = undefined;

	var showCurrentFile = function() {
	  var i, filename, filenames = [ ];
	  var files = $('.filename', revertForkDiv);
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
	  $('.filename', revertForkDiv).each(function() {
		$(this).click(function() {
		  var filename = $(this).text();
		  var content = visibleFiles[filename];
		  revertForkContent.val(content);
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

	var firstButton = $('#first_button', revertForkDiv);
	var prevButton  = $('#prev_button',  revertForkDiv);
	var nextButton  = $('#next_button',  revertForkDiv);
	var lastButton  = $('#last_button',  revertForkDiv);

    var resetNavigateButtonHandlers = function() {
	  var resetHandler = function(button, onOff, newTag) {
		button
		  .attr('disabled', onOff)
		  .unbind()
		  .click(function() {
			if (!onOff) {
			  tag = newTag;
			  revertButton = $(this); // wait-cursor hack
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
	  var cursor = revertButton.css('cursor');
	  revertButton.css('cursor', 'wait');
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
		  revertForkFilenames.html(makeRevertForkFilenames(data.visibleFiles));
		  showContentOnFilenameClick(data.visibleFiles);
          showCurrentFile();
		  if (open !== undefined) {
			open();
		  }
		}
	  ).always(function() {
        revertButton.css('cursor', cursor);
	  })
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	refresh(function() {
	  // only open after all html-loaded otherwise
	  // dialog may not center on the page.
	  revertForkDialog.dialog('open');
	});

  }; // cd.dialog_revert = function(title, cancel, id, avatarName, tag, maxTag) {


  return cd;
})(cyberDojo || {}, $);
