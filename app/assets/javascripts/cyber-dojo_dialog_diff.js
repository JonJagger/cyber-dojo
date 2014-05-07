/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.setupTrafficLightOpensDiffDialogHandlers = function(lights) {
	lights.click(function() {
	  var light = $(this);
	  var id = light.data('id');
	  var avatarName = light.data('avatar-name');
	  var wasTag = light.data('was-tag');
	  var nowTag = light.data('now-tag');
	  var maxTag = light.data('max-tag');
	  cd.dialog_diff(id, avatarName, wasTag, nowTag, maxTag, light);
	});
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.dialog_diff = function(id, avatarName, wasTag, nowTag, maxTag, diffLight) {

  	var minTag = 0;
    var tagGap = nowTag - wasTag;

    var makeDiffInfo = function() {
	  return '' +
	    '<table id="diff-info">' +
		  '<tr>' +
		    '<td>' +
			  '<div id="was-traffic-light">' +
			  '</div>' +
		    '</td>' +
			'<td>' +
			  '<input type="text" id="was-tag-number" value="' + wasTag + '" />' +
			'</td>' +
			'<td>' +
			  '&thinsp;&lrarr;' +
			'</td>' +
			'<td>' +
			  '<input type="text" id="now-tag-number" value="' + nowTag + '" />' +
			'</td>' +
		    '<td>' +
			  '<div id="now-traffic-light">' +
			  '</div>' +
		    '</td>' +
		  '</tr>' +
		'</table>';
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var makeDiffDiv = function()  {
      var div = $('<div>', {
        'id': 'diff-dialog'
      });
      var table = $('<table>');
      table.append(
        "<tr valign='top'>" +
          "<td valign='top'>" +

		    "<table>" +
			  "<tr valign='top' align='right'>" +
				"<td valign='top'>" +
			      makeDiffInfo() +
			    "</td>" +
			  "</tr>" +

			  "<tr>" +
			    "<td>" +
				  "<hr/>" +
				"</td>" +
			  "</tr>" +
			  
			  "<tr valign='top'>" +
				"<td valign='top'>" +
				  cd.makeNavigateButtons(avatarName) +
				"</td>" +
			  "</tr>" +

			  "<tr>" +
			    "<td>" +
				  "<hr/>" +
				"</td>" +
			  "</tr>" +

			  "<tr valign='top' align='right'>" +
				"<td valign='top'>" +
				  "<div id='diff-filenames'>" +
				  "</div>" +
				"</td>" +
			  "</tr>" +

			"</table>" +

          "</td>" +
          "<td>" +
            "<div id='diff-content'>" +
		    "</div>" +
          "</td>" +
	    "</tr>");

      div.append(table);
      return div;
    };

    var diffDiv = makeDiffDiv();

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var wasTagNumber = $('#was-tag-number', diffDiv);
	var tagGapNumber = $('#tag-gap-number', diffDiv);
	var nowTagNumber = $('#now-tag-number', diffDiv);

	var wasTrafficLight = $('#was-traffic-light', diffDiv);
	var nowTrafficLight = $('#now-traffic-light', diffDiv);

	var firstButton = $('#first_button', diffDiv);
	var prevButton  = $('#prev_button',  diffDiv);
	var nextButton  = $('#next_button',  diffDiv);
	var lastButton  = $('#last_button',  diffDiv);

    var resetNavigateButtonHandlers = function() {

	  var toolTip = function(was, now) {
		if (was !== now) {
		  return 'Show diff of ' + was + ' <-> ' + now;
		} else {
		  return 'Show ' + was;
		}
	  };

	  var showDiff = function(was,now) {
		wasTag = was;
		nowTag = now;
		tagGap = now - was;
		refresh();
	  };

	  var tagEdit = function(event) {
		if (event.keyCode === $.ui.keyCode.ENTER) {
		  var newWasTag = parseInt(wasTagNumber.val(), 10);
		  var newNowTag = parseInt(nowTagNumber.val(), 10);
		  if (isNaN(newWasTag) || newWasTag < minTag ||
				isNaN(newNowTag) || newNowTag > maxTag ||
				  newWasTag > newNowTag) {
			wasTagNumber.val(wasTag);
			nowTagNumber.val(nowTag);
		  } else {
			diffLight = $(event.target); // wait-cursor hack
			showDiff(newWasTag, newNowTag);
		  }
		}
	  };

	  var refreshNavigationHandlers = function(off, button, from, to) {
		button.attr('disabled', off);
		if (!off) {
		  button.unbind()
			.click(function() {
			  diffLight = $(this); // wait-cursor hack
			  showDiff(from, to);
			})
			.attr('title', toolTip(from, to));
		}
	  };

	  // The wasTagNumber and nowTagNumber may have been edited since the
	  // refresh but before a navigation button is pressed. However, the
	  // navigation buttons do _not_ look at the current state of
	  // wasTagNumber/nowTagNumber, but use the values set on refresh.
	  // This is the simplest way to ensure the navigation buttons are
	  // not incorrectly enabled/disabled.
	  refreshNavigationHandlers(minTag >= wasTag, firstButton, minTag, minTag+tagGap);
	  refreshNavigationHandlers(minTag >= wasTag, prevButton, wasTag-1, nowTag-1);
	  refreshNavigationHandlers(nowTag >= maxTag, nextButton, wasTag+1, nowTag+1);
	  refreshNavigationHandlers(nowTag >= maxTag, lastButton, maxTag-tagGap, maxTag);

	  wasTagNumber.unbind().keyup(function(event) { tagEdit(event); });
	  nowTagNumber.unbind().keyup(function(event) { tagEdit(event); });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

  	var makeTrafficLight = function(tag, trafficLight) {
	  var colour = trafficLight.colour || trafficLight.outcome
	  if (tag == 0) {
		colour = 'white';
	  }
      return '' +
		"<img src='/images/" + 'traffic_light_' + colour + ".png'" +
		     "width='15'" +
		     "height='46'/>";
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var diffContent = $('#diff-content', diffDiv);

    var makeDiffContent = function(diffs) {
	  var holder = $('<span>');
	  $.each(diffs, function(_, diff) {
		var table = $('' +
		  '<div id="' + diff.filename + '_diff_div" class="filename_div">' +
		  '<table>' +
		    '<tr class="valign-top">' +
		      '<td>' +
		        '<div id="diff_file_content_for_' + diff.filename + '" class="diff-sheet">' +
				'</div>' +
		      '</td>' +
		      '<td>' +
		        '<div class="diff-line-numbers">' +
				'</div>' +
		      '</td>' +
		    '</tr>' +
		  '</table>' +
		  '</div>'
	    );
		var content = $('.diff-sheet', table);
		var numbers = $('.diff-line-numbers', table);
		content.html(diff.content);
		numbers.html(diff.line_numbers);
		cd.bindLineNumbersFromTo(content, numbers);
		holder.append(table);
	  });
	  return holder;
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var buildDiffFilenameHandlers = function(diffs) {
	  // Builds the diff filename click handlers for a given kata-id,
	  // given animal-name, and given traffic-light was-tag/now-tag numbers.
	  // Clicking on the filename brings it into view by hiding the
	  // previously selected file and showing the selected one.
	  //
	  // The first time the filename for a file with one or more
	  // diff-sections is clicked its diff-section is scrolled into view.
	  //
	  // Subsequent times if you click on the filename you will _not_ get
	  // an autoscroll. This is so that the scrollPos of a diff that has
	  // been manually scrolled is retained.
	  //
	  // However, if filename X is open and you reclick on filename X
	  // then you _will_ get an autoscroll to the _next_ diff-section in that
	  // diff (which will cycle round).

	  var previousFilenameNode;
	  var alreadyOpened = [ ];
	  var getFilename = function(node) {
		return $.trim(node.text());
	  };

	  var diffFileContentFor = function(filename) {
		return cd.id('diff_file_content_for_' + filename);
	  };

	  var diffFileDiv = function(filename) {
		return cd.id(filename + '_diff_div');
	  };

	  var loadFrom = function(filename, filenameNode, id, sectionCount) {

		var diffSheet = diffFileContentFor(filename);
		var sectionIndex = 0;

		if (sectionCount > 0) {
			filenameNode.attr('title', 'Auto-scroll through diffs');
		}

		return function() {
		  var reselected =
			previousFilenameNode !== undefined && getFilename(previousFilenameNode) === filename;

		  var allLineCountButtons = $('.diff-deleted-line-count, .diff-added-line-count');
		  var off = { 'disabled':true, 'title':'' };
		  var disableAllLineCountButtons = function() {
			allLineCountButtons.attr(off);
		  };
		  var tr = filenameNode.closest('tr');
		  disableAllLineCountButtons();
		  tr.find('.diff-deleted-line-count')
			  .attr('disabled', false)
			  .attr('title', 'Toggle deleted lines on/off');
		  tr.find('.diff-added-line-count')
			  .attr('disabled', false)
			  .attr('title', 'Toggle added lines on/off');

		  cd.radioEntrySwitch(previousFilenameNode, filenameNode);
		  if (previousFilenameNode !== undefined) {
			diffFileDiv(getFilename(previousFilenameNode)).hide();
		  }
		  diffFileDiv(getFilename(filenameNode)).show();
		  previousFilenameNode = filenameNode;

		  if (sectionCount > 0 && (reselected || !cd.inArray(filename, alreadyOpened))) {
			var section = $('#' + id + '_section_' + sectionIndex);
			var downFromTop = 150;
			var halfSecond = 500;
			diffSheet.animate({
			  scrollTop: section.offset().top - diffSheet.offset().top - downFromTop
			  }, halfSecond);
			sectionIndex += 1;
			sectionIndex %= sectionCount;
		  }
		  alreadyOpened.push(filename);
		};
	  };

	  $.each(diffs, function(_n, diff) {
		var filenameNode = $('#radio_' + diff.id);
		var filename = getFilename(filenameNode);
		filenameNode.click(loadFrom(filename, filenameNode, diff.id, diff.section_count));
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var diffFilenames = $('#diff-filenames', diffDiv);

    var makeDiffFilenames = function(diffs) {

      var table= $('<table>');
      $.each(diffs, function(_, diff) {
		var tr = $('<tr>');
		var td = $('<td>', { 'class': 'align-right' });

        var filenameDiv = $('<div>', {
          'class': 'filename',
		  'id': 'radio_' + diff.id,
          'text': diff.filename
        });

		var deletedLineCountTd = undefined;
		if (diff.deleted_line_count > 0) {
		  deletedLineCountTd = $('<td>', {
			'class': 'align-right diff-deleted-line-count button',
			'data-filename': diff.filename
		  });
		  deletedLineCountTd.append(diff.deleted_line_count);
		} else {
		  deletedLineCountTd = $('<td>');
		}

		var addedLineCountTd = undefined;
		if (diff.added_line_count > 0) {
		  addedLineCountTd = $('<td>', {
			'class': 'align-right diff-added-line-count button',
			'data-filename': diff.filename
		  });
		  addedLineCountTd.append(diff.added_line_count);
		} else {
		  addedLineCountTd = $('<td>');
		}

		td.append(filenameDiv);
		tr.append(deletedLineCountTd);
		tr.append(addedLineCountTd)
		tr.append(td);
        table.append(tr);
      });

      return table.html();
    };

	var resetFilenameAddedDeletedLineCountHandlers = function() {
	  var display = function(node, name, value) {
		if ($(node).attr('disabled') !== 'disabled') {
		  var filename = $(node).data('filename');
		  var selector = '[id="' + filename + '_diff_div"] ' + name;
		  $(selector, diffDiv).css('display', value);
		}
	  };

	  $('.diff-deleted-line-count', diffDiv).clickToggle(
		function() { display(this, 'deleted', 'none' ); },
		function() { display(this, 'deleted', 'block'); }
	  );

	  $('.diff-added-line-count', diffDiv).clickToggle(
		function() { display(this, 'added', 'none' ); },
		function() { display(this, 'added', 'block'); }
	  );
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var showCurrentFile = function(filenameId) {
	  $('#radio_' + filenameId).click();
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var diffDialog = diffDiv.dialog({
	  autoOpen: false,
	  width: 1100,
	  height: "auto",
	  modal: true,
	  buttons: {
		close: function() {
		  $(this).dialog('close');
		}
	  }
	});

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var refresh = function(open) {
	  var cursor = diffLight.css('cursor');
	  diffLight.css('cursor', 'wait');
	  $.getJSON('/differ/diff',
		{
		  id: id,
		  avatar: avatarName,
		  was_tag: wasTag,
		  now_tag: nowTag
		},
		function(data) {
		  resetNavigateButtonHandlers();

		  wasTrafficLight.html(makeTrafficLight(wasTag, data.wasTrafficLight));
		  wasTagNumber.val(wasTag);
		  tagGapNumber.html(tagGap);
		  nowTagNumber.val(nowTag);
		  nowTrafficLight.html(makeTrafficLight(nowTag, data.nowTrafficLight));

		  diffFilenames.html(makeDiffFilenames(data.diffs));
		  resetFilenameAddedDeletedLineCountHandlers();
		  diffContent.html(makeDiffContent(data.diffs));
          buildDiffFilenameHandlers(data.idsAndSectionCounts);
          showCurrentFile(data.currentFilenameId);
		  if (open !== undefined) {
			open();
		  }
		}
	  ).always(function() {
        diffLight.css('cursor', cursor);
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	refresh(function() {
	  // only open after all html-loaded otherwise
	  // dialog may not center on the page.
	  diffDialog.dialog('open');
	});


  }; // cd.dialog_diff = function(id, avatarName, wasTag, nowTag, maxTag) {


  return cd;
})(cyberDojo || {}, $);
