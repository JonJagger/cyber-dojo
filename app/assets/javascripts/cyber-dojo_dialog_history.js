/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.setupTrafficLightOpensHistoryDialogHandlers = function(lights,showRevert) {
	lights.click(function() {
	  var light = $(this);
	  var id = light.data('id');
	  var avatarName = light.data('avatar-name');
	  var wasTag = light.data('was-tag');
	  var nowTag = light.data('now-tag');
	  var maxTag = light.data('max-tag');
	  cd.dialog_history(id,avatarName,wasTag,nowTag,maxTag,light,showRevert);
	});
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.setupTrafficLightCountOpensCurrentCode = function(bulbs,showRevert) {
    $.each(bulbs, function(_,bulb) {
	  var count = $(bulb);
	  var id = count.data('id');
	  var avatarName = count.data('avatar-name');
	  var wasTag = count.data('bulb-count');
	  var nowTag = count.data('bulb-count');
	  var maxTag = count.data('bulb-count');
	  var colour  = count.data('current-colour');
	  // animals don't appear on dashboard until they have 2+ traffic-lights
	  // so pluralization of traffic-lights is ok
	  var toolTip = avatarName + ' has ' + wasTag + ' traffic-lights' +
	    ' and is at ' + colour + '.' +
		' Click to review ' + avatarName + "'s current code.";
	  count.attr('title', toolTip);
	  count.click(function() {
	    cd.dialog_history(id,avatarName,wasTag,nowTag,maxTag,count,showRevert);
	  });
	});
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - -
  // Arguably, the history dialog would be better as it own
  // history page. That would help google searchability and
  // analytics etc. I use a dialog because that is the only
  // way I can think of to implement revert.
  // When revert is clicked it has to be for a specific
  // animal and it has to revert their code! As a dialog,
  // the revert has access to animal's code on the page
  // from which the dialog opened.

  cd.dialog_history = function(id, avatarName,
							   wasTag, nowTag, maxTag,
							   diffLight, showRevert) {
	// diffLight isn't necessarily a traffic-light.
	// It is whatever dom element's click handler causes
	// dialog_history() to be called.
	// Eg it could be an animals light-count which opens
	// a "no-diff" by setting wasTag == nowTag.
	// It has its cursor tweaked while the getJSON call is made.

	var minTag = 0;
	var tagGap = nowTag - wasTag;
	var currentFilename = '';

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var td = function(html) {
	  return '<td>' + html + '</td>';
	};

	var makeWasTagControl = function(tag) {
	  return '' +
	    '<table class="tag-control">' +
		  '<tr>' +
			td('<input type="text" id="was-tag-number" value="' + tag + '" />') +
 		    td('<div id="was-traffic-light"></div>') +
		  '</tr>' +
		'</table>';
	}

	var makeNowTagControl = function(tag) {
	  return '' +
	    '<table class="tag-control">' +
		  '<tr>' +
 		    td('<div id="now-traffic-light"></div>') +
			td('<input type="text" id="now-tag-number" value="' + tag + '" />') +
		  '</tr>' +
		 '</table>';
	};

    var makeDiffTagControl = function() {
	  return '' +
	    '<table id="diff-tag-control">' +
		  '<tr>' +
		    td(makeWasTagControl(wasTag)) +
			td('<div id="diff-arrow">&harr;</div>') +
		    td(makeNowTagControl(nowTag)) +
		  '</tr>' +
		'</table>';
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var makeDiffDiv = function()  {
      var div = $('<div>', {
        'id': 'history-dialog'
      });
      div.append('<div id="diff-content"></div>');
	  div.append('<div id="diff-controls">' +
					cd.makeNavigateButtons() +
					"<div id='diff-filenames'></div>" +
				 '</div>');
      return div;
    };

	var diffDiv = makeDiffDiv();

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var titleBar = function() {
	  return $('#ui-dialog-title-history-dialog');
	};

	var wasTagNumber = function() {
	  return $('#was-tag-number', titleBar());
	};

	var nowTagNumber = function() {
	  return $('#now-tag-number', titleBar());
	};

	var wasTrafficLight = function() {
	  return $('#was-traffic-light', titleBar());
	};

	var nowTrafficLight = function() {
	  return $('#now-traffic-light', titleBar());
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var firstButton = $('#first_button', diffDiv);
	var prevButton  = $('#prev_button',  diffDiv);
	var nextButton  = $('#next_button',  diffDiv);
	var lastButton  = $('#last_button',  diffDiv);

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

    var resetNavigateButtonHandlers = function() {
	  refreshNavigationHandlers(minTag >= wasTag, firstButton, minTag, minTag+tagGap);
	  refreshNavigationHandlers(minTag >= wasTag, prevButton, wasTag-1, nowTag-1);
	  refreshNavigationHandlers(nowTag >= maxTag, nextButton, wasTag+1, nowTag+1);
	  refreshNavigationHandlers(nowTag >= maxTag, lastButton, maxTag-tagGap, maxTag);
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

  	var makeTrafficLight = function(tag, trafficLight) {
	  var colour = trafficLight.colour || trafficLight.outcome
	  if (tag == 0) {
		colour = 'white';
	  }
      return '' +
		"<img src='/images/" + 'traffic_light_' + colour + ".png'" +
		     "width='10'" +
		     "height='32'/>";
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
		        '<div class="diff-line-numbers"></div>' +
		      '</td>' +
		      '<td>' +
		        '<div id="diff_file_content_for_' + diff.filename + '" class="diff-sheet">' +
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
	  // Builds the diff filename click handlers for a given
	  // [ kata-id, animal-name, was-tag, now-tag] tuple.
	  //
	  // Clicking on the filename brings it into view by hiding the
	  // previously selected file and showing the selected one.
	  //
	  // The first time a filename X with one or more diff-sections is
	  // clicked it is opened and its first diff-section is auto
	  // scrolled into view. If you open a different file and then reclick
	  // filename X you will *not* get an autoscroll to the next diff.
	  // This is so the scrollPos of a file is retained as you move
	  // from one file to another, manually scrolling.
	  //
	  // However, if filename X is already open and you reclick
	  // on filename X then you *will* get an autoscroll to the
	  // *next* diff-section in that diff (which will cycle round).

	  var previousFilenameNode;
	  var alreadyOpened = [ ];

	  var getFilename = function(node) {
		return $.trim(node.text());
	  };

	  var id = function(name) {
	    return $('[id="' + name + '"]', diffDiv);
	  };

	  var diffFileContentFor = function(filename) {
		return id('diff_file_content_for_' + filename);
	  };

	  var diffFileDiv = function(filename) {
		return id(filename + '_diff_div');
	  };

	  var loadFrom = function(diff) {

		var id = diff.id;
		var filenameNode = $('#radio_' + id, diffDiv);
		var filename = getFilename(filenameNode);
		var sectionCount = diff.section_count;

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
		  currentFilename = filename;

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
		var filename = $('#radio_' + diff.id, diffDiv);
		filename.click(loadFrom(diff));
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

		var dlc = (diff.deleted_line_count === 0 ||
				  diff.filename === 'output') ? 'none' : 'some';
		var deletedLineCountTd = $('<td>', {
		  'class': 'diff-deleted-line-count ' + dlc + ' button',
		  'data-filename': diff.filename
		});

		var alc = (diff.added_line_count === 0 ||
				  diff.filename === 'output') ? 'none' : 'some';
		var addedLineCountTd = $('<td>', {
		  'class': 'diff-added-line-count ' + alc + ' button',
		  'data-filename': diff.filename
		});

		if (diff.deleted_line_count > 0) {
		  deletedLineCountTd.append(diff.deleted_line_count);
		}
		if (diff.added_line_count > 0) {
		  addedLineCountTd.append(diff.added_line_count);
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

	var showFile = function(filenameId) {
	  $('#radio_' + filenameId, diffDiv).click();
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var closeDiffDialog = function() {
	  // It's important to call remove() and not
	  // close() to ensure the dialog is totally
	  // removed from the dom and to do this in
	  // *both* the close button and hitting escape.
	  // If you don't do this then things don't
	  // work properly. Eg the initial selection
	  // of the chosen filename does not work when
	  // reopening the dialog.
	  diffDialog.remove();
	};

	var title = '' +
	  '<img height="30"' +
	  ' width="30"' +
	  ' src="/images/avatars/' + avatarName + '.jpg"/>' +
      ' history ' +
	  makeDiffTagControl();

	var buttons = {};
	buttons['close'] = function() {
	  closeDiffDialog();
	};
	buttons['fork'] = function() {
	  doFork();
	};
	if (showRevert) {
	  buttons['revert'] = function() {
		doRevert();
		closeDiffDialog();
	  };
	}

	var diffDialog = diffDiv.dialog({
	  autoOpen: false,
	  title: cd.dialogTitle(title),
	  width: 1150,
	  height: 720,
	  modal: true,
      buttons: buttons,
	  open: function() { refresh(); }
	}).on('keydown', function(event) {
	  if (event.keyCode === $.ui.keyCode.ESCAPE) {
		closeDiffDialog();
	  }
	  event.stopPropagation();
	});

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var colouredBulb = function(light) {
	  var colour = light.colour || light.outcome;
      return '' +
	    '<span class="revert-fork-bulb-edge">' +
		  "<img  src='/images/" + 'bulb_' + colour + ".png'" +
			  "width='12'" +
			 "height='12'/>" +
		"</span>";
	};

	var revertButton = function() {
	  return $('.ui-dialog-buttonset :nth-child(3) :first-child');
	};

	var makeRevertButtonHtml = function(data,nowTag) {
	  return '' +
	    'revert to ' +
	    nowTag + ' ' +
		colouredBulb(data.nowTrafficLight);
	};

	var doRevert = function() {
	  deleteAllCurrentFiles();
	  copyRevertFilesToCurrentFiles();
	  $('#test-button').click();
	};

	var deleteAllCurrentFiles = function() {
	  $.each(cd.filenames(), function(_, filename) {
		if (filename !== 'output') {
		  cd.doDelete(filename);
		}
	  });
	};

	var copyRevertFilesToCurrentFiles = function() {
	  var filename;
	  for (filename in visibleFiles) {
		if (filename !== 'output') {
		  cd.newFileContent(filename, visibleFiles[filename]);
		}
	  }
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var forkButton = function() {
	  return $('.ui-dialog-buttonset :nth-child(2) :first-child');
	};

	var makeForkButtonHtml = function(data,nowTag) {
	  return '' +
	    'fork from ' +
	    nowTag + ' ' +
		colouredBulb(data.nowTrafficLight);
	};

	var doFork = function() {
	  $.getJSON('/forker/fork', {
		id: id,
		avatar: avatarName,
		tag: nowTag
	  }, function(data) {
		if (data.forked) {
		  forkSucceededDialog(data);
		} else {
		  forkFailedDialog(data);
		}
	  });
	};

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

	var visibleFiles = undefined;

	var refresh = function() {
	  diffLight.css('cursor', 'wait');
	  $.getJSON('/differ/diff',
		{
		  id: id,                // 43:dialog_diff(id...)
		  avatar: avatarName,    // 43:dialog_diff(... avatarName...)
		  was_tag: wasTag,       // 43:dialog_diff(... wasTag ...)
		  now_tag: nowTag,       // 43:dialog_diff(... nowTag ...)
		  current_filename: currentFilename // 51:var currentFilename
		},
		function(data) {

		  visibleFiles = data.visibleFiles;
		  resetNavigateButtonHandlers();
		  wasTrafficLight().html(makeTrafficLight(wasTag, data.wasTrafficLight));
		  wasTagNumber().val(wasTag);
		  nowTagNumber().val(nowTag);
		  nowTrafficLight().html(makeTrafficLight(nowTag, data.nowTrafficLight));

		  diffFilenames.html(makeDiffFilenames(data.diffs));
		  resetFilenameAddedDeletedLineCountHandlers();
		  diffContent.html(makeDiffContent(data.diffs));
          buildDiffFilenameHandlers(data.idsAndSectionCounts);
          showFile(data.currentFilenameId);

		  if (showRevert) {
			revertButton().html(makeRevertButtonHtml(data,nowTag));
		  }
		  forkButton().html(makeForkButtonHtml(data,nowTag));

		}
	  ).always(function() {
        diffLight.css('cursor', 'pointer');
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    diffDialog.dialog('open');


  }; // cd.dialog_history = function(id,avatarName,
    //                               wasTag,nowTag,maxTag,
	//                               difLight,showRevert) {

  return cd;
})(cyberDojo || {}, $);
