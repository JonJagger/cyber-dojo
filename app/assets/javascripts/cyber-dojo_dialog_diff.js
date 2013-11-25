/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // http://stackoverflow.com/questions/4911577/jquery-click-toggle-between-two-functions
  // $().toggle() no longer exists in JQuery
  $.fn.clickToggle = function(func1, func2) {
    var funcs = [func1, func2];
    this.data('toggleclicked', 0);
    this.click(function() {
      var data = $(this).data();
      var tc = data.toggleclicked;
      $.proxy(funcs[tc], this)();
      data.toggleclicked = (tc + 1) % 2;
    });
    return this;
  };

  cd.dialog_diff = function(title, id, avatarName, wasTag, nowTag, maxTag) {    
  
  	var minTag = 0;
    var tagGap = nowTag - wasTag;

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
            "<div id='diff_content'>" +
		    "</div>" +
          "</td>" +
	    "</tr>");
	  
      div.append(table);	   
      return div;
    };
	
    var diff = makeDiffDiv();
	
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	// UNUSED
    var diffContent = $('#diff_content', diff);
	
	// UNUSED
	var currentFilename = undefined;
	
	// UNUSED
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
	
	// UNUSED
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
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var wasTagNumber = $('#was_tag_number', diff);
	var nowTagNumber = $('#now_tag_number', diff);
		
	var wasTrafficLight = $('#was_traffic_light', diff);
	var nowTrafficLight = $('#now_traffic_light', diff);
	
	var firstButton = $('#first_button', diff);
	var prevButton  = $('#prev_button',  diff);
	var nextButton  = $('#next_button',  diff);
	var lastButton  = $('#last_button',  diff);
	  
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
			showDiff(newWasTag, newNowTag);
		  }
		}        
	  };

	  var refreshNavigationHandlers = function(off, b1, b2, b1From, b1To, b2From, b2To) {
		b1.attr('disabled', off);
		b2.attr('disabled', off)
		if (!off) {
		  b1.unbind()
			.click(function() { showDiff(b1From, b1To); })
			.attr('title', toolTip(b1From, b1To));			  
		  b2.unbind()
			.click(function() { showDiff(b2From, b2To); })
			.attr('title', toolTip(b2From, b2To));	
		}
	  };
	
	  refreshNavigationHandlers(minTag >= wasTag, firstButton, prevButton, minTag, minTag+tagGap, wasTag-1, nowTag-1);
	  refreshNavigationHandlers(nowTag >= maxTag, nextButton, lastButton, wasTag+1, nowTag+1, maxTag-tagGap, maxTag);

	  wasTagNumber.unbind('keyup').keyup(function(event) { tagEdit(event); });  
	  nowTagNumber.unbind('keyup').keyup(function(event) { tagEdit(event); });
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
	// DIFF-CONTENT
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var diffContent = $('#diff_content', diff);

    var makeDiffContent = function(diffs) {
	  var span = $('<span>');
	  $.each(diffs, function(_, diff) {
		var divHolder = $('<div>', {
		  id: diff.filename + '_diff_div',
		  'class': 'filename_div'
		});
		var div = $('<div>', {
		  id: 'diff_file_content_for_' + diff.filename,
		  'class': 'diff_sheet'
		});
		div.html(diff.content);
		divHolder.append(div);
		span.append(divHolder);
	  });
	  return span;
/*	  
<% @diffs.each do |diff| %>
  <% filename = diff[:filename] %>

  <div id="<%= filename %>_div"
       class="filename_div">
    <table class="edgeless panel">
      <tr>
        <td>
          <div id="<%= filename %>_line_numbers"
               class="diff_line_numbers align-right">
            <%= raw diff[:line_numbers] %>
          </div>
        </td>
        <td>
          <div id="file_content_for_<%= filename %>"
               class="diff_sheet">
            <%= raw diff[:content] %>
          </div>
        </td>
      </tr>
    </table>
    <div class="panel"></div>      
  </div>
  
<% end %>  
*/	  
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	// DIFF-FILENAME-HANDLERS
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var buildDiffFilenameHandlers = function(diffs) {
  
	  var previousFilenameNode;
	  var alreadyOpened = [ ];
	  var getFilename = function(node) {
		return $.trim(node.text());
	  };
	  
	  var diffId = function(name) {
		return $('[id="' + name + '"]');
	  };
	  
	  var diffFileContentFor = function(filename) {
		return diffId('diff_file_content_for_' + filename);
	  };
	
	  var diffFileDiv = function(filename) {
		return diffId(filename + '_diff_div');
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
		//cd.bindLineNumbersEvents(filename);
	  });
	};

    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	// DIFF-FILENAMES
    //- - - - - - - - - - - - - - - - - - - - - - - - - -

	var diffFilenames = $('#diff_filenames', diff);

    var makeDiffFilenames = function(diffs) {
	  
	  var display = function(node, name, value) {
		if ($(node).attr('disabled') !== 'disabled') {
		  var filename = $(node).data('filename');
		  var selector = '[id="' + filename + '_div"] ' + name;
		  $(selector, diff).css('display', value);
		}
	  };
	  
      var table= $('<table>');
      $.each(diffs, function(_, diff) {
		var tr = $('<tr>');
		var td = $('<td>', { 'class': 'align-left' });
	  
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
		tr.append(td);
		tr.append(deletedLineCountTd);
		tr.append(addedLineCountTd)
        table.append(tr);		
      });
	  
	  $('.diff-deleted-line-count', diff).clickToggle(
		function() { display(this, 'deleted', 'none' ); },
		function() { display(this, 'deleted', 'block'); }    
	  );
	
	  $('.diff-added-line-count', diff).clickToggle(
		function() { display(this, 'added', 'none' ); },
		function() { display(this, 'added', 'block'); }    
	  );
	  
      return table.html();
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
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

	var data = undefined;
	// data.wasTrafficLight
	// data.nowTrafficLight
	// data.diffs
	// data.idsAndSectionCounts
	// data.currentFilenameId
	
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
		  resetNavigateButtonHandlers();
		  wasTagNumber.val(wasTag);
		  wasTrafficLight.html(makeTrafficLight(data.wasTrafficLight));
		  nowTrafficLight.html(makeTrafficLight(data.nowTrafficLight));
		  nowTagNumber.val(nowTag);
		  diffFilenames.html(makeDiffFilenames(data.diffs));
		  diffContent.html(makeDiffContent(data.diffs));
		  //showContentOnFilenameClick();
          //showCurrentFile();
          buildDiffFilenameHandlers(data.idsAndSectionCounts);

		}
	  );
	};
	  
    //- - - - - - - - - - - - - - - - - - - - - - - - - -
	
	diffDialog.dialog('open');
	refresh();
	
  }; // cd.dialog_diff = function(title, id, avatarName, wasTag, nowTag, maxTag) {


  return cd;
})(cyberDojo || {}, $);

