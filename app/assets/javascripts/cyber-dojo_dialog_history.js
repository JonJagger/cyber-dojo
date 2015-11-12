/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Arguably, the history would be better as it own page rather
  // than a dialog. That would help google searchability and
  // analytics and useability and restfulness etc.
  // I use a dialog because of revert.
  // When revert is clicked it has to be for a *specific*
  // animal and it has to revert their code! As a dialog,
  // the revert has access to animal's code on the page
  // from which the history-dialog opened.
  // An alternative would be to do a post for the animal
  // and then get the server to push a notification to the
  // animal or get the animl to poll an update from the server.
  // But I currently don't have any server -> browser
  // interaction and I'm not sure I want any.

  cd.td = function(html) {
	  return '<td>' + html + '</td>';
  };
                                            // eg
  cd.dialog_history = function(id,          // 'D936E1EB3F'
                               avatarName,  // 'lion'
                               wasTagParam, // 8   (1-based)
                               nowTagParam, // 9   (1-based)
                               showRevert   // true
                              ) {

    var currentFilename = '';
    var data = {
      wasTag: wasTagParam,
      nowTag: nowTagParam
    };
    var wasTag = function() {
      return data.wasTag;
    };
    var nowTag = function() {
      return data.nowTag;
    };
    var inDiffMode = function() {
      return wasTag() != nowTag();
    }
    var titleBar = function() {
      return $('#ui-dialog-title-history-dialog');
    };
    var td = function(align,html) {
      return '<td align="' + align + '">' + html + '</td>';
    };


    //-------------------------------------------------------
    // diff? [x] traffic-lights [<< < tag > >>]  [< avatar >]
    //-------------------------------------------------------

    var makeTitleHtml = function() {
      return '<table>' +
               '<tr valign="top">' +
                 cd.td(makeDiffTitleHtml()) +
                 cd.td(makeDiffCheckboxHtml()) +
                 cd.td('<div id="traffic-lights"></div>') +
                 cd.td(makeTagNavigationHtml()) +
                 cd.td(makeAvatarNavigationHtml()) +
               '</tr>' +
             '</table>';
    };

    //---------------------------------------------------
    // diff? [x]
    //---------------------------------------------------

    var makeDiffTitleHtml = function() {
      return '<div id="title">diff?</div>';
    };

    var makeDiffCheckboxHtml = function() {
      return '<input type="checkbox"' +
                   ' class="regular-checkbox"' +
                   ' id="diff-checkbox"' +
                   ' checked="' + (inDiffMode() ? "checked" : "") + '"/>' +
              '<label for="diff-checkbox"></label>';
    };

    //- - - - - - - - - - - - - - -

    var diffCheckBox = function() {
      return $('#diff-checkbox', titleBar());
    };

    //- - - - - - - - - - - - - - -
    // refresh diff? [x]
    //- - - - - - - - - - - - - - -

    var refreshDiffCheckBox = function() {
      diffCheckBox()
        .html(makeDiffCheckboxHtml())
        .attr('checked', inDiffMode())
        .unbind('click')
        .bind('click', function() { show(nowTag()); });
    }

    //---------------------------------------------------
    // traffic-lights
    //---------------------------------------------------

    var makeTrafficLightsHtml = function(lights) {
      var html = '';
      var index = 1;
      $.each(lights, function(n,light) {
        var barGap = (nowTag() === light.number) ? 'bar' : 'gap';
        html +=
          "<div class='traffic-light'>" +
            "<img src='/images/bulb_" + light.colour + '_' + barGap + ".png'" +
                " data-index='" + index + "'" +
                " data-tag='" + light.number + "'/>" +
          "</div>";
          index += 1;
      });
      return html;
    };

    //- - - - - - - - - - - - - - -

    var trafficLights = function() {
      return $('#traffic-lights', titleBar());
    };

    //- - - - - - - - - - - - - - -
    // refresh traffic-lights
    //- - - - - - - - - - - - - - -

    var refreshTrafficLights = function() {
      trafficLights().html(makeTrafficLightsHtml(data.lights));
      $.each($('img[src$="_gap.png"]', titleBar()), function(_,light) {
        var index = $(this).data('index');
        var tag = $(this).data('tag');
        $(this)
          .attr('title', toolTip(index))
          .click(function() { show(tag); });
      });
    };

    //---------------------------------------------------
    // << < tag  > >>
    //---------------------------------------------------

    var makeTagNavigationHtml = function() {
      return '<table class="navigate-control">' +
               '<tr valign="top">' +
                 td('right',  makeTagButtonHtml('first')) +
                 td('right',  makeTagButtonHtml('prev')) +
                 td('center', makeNowTagNumberHtml()) +
                 td('left',   makeTagButtonHtml('next')) +
                 td('left',   makeTagButtonHtml('last')) +
               '</tr>' +
             '</table>';
    };

    //- - - - - - - - - - - - - - -

    var makeTagButtonHtml = function(name) {
      return '<button class="triangle button"' +
                       ' id="' + name + '-button">' +
               '<img src="/images/triangle_' + name + '.gif"' +
                   ' alt="move to ' + name + ' diff"/>' +
             '</button>';
    };

    //- - - - - - - - - - - - - - -

    var makeNowTagNumberHtml = function() {
      return '<div id="now-tag-number"/></div>';
    };

    //- - - - - - - - - - - - - - -
    // refresh << < tag  > >>
    //- - - - - - - - - - - - - - -

    var refreshTagControls = function() {
      var colour = data.lights[nowTag()-1].colour;
      var minTag = 1;
      var maxTag = data.lights.length;
      var tagsToLeft = minTag < nowTag();
      var tagsToRight = nowTag() < maxTag;
      $('#now-tag-number')
        .removeClass()
        .addClass(colour)
        .html(nowTag());
      refreshTag(tagsToLeft,  $('#first-button'), minTag);
      refreshTag(tagsToLeft,  $('#prev-button'),  nowTag()-1);
      refreshTag(tagsToRight, $('#next-button'),  nowTag()+1);
      refreshTag(tagsToRight, $('#last-button'),  maxTag);
    };

    //- - - - - - - - - - - - - - -

    var refreshTag = function(on, button, newTag) {
      button
        .attr('disabled', !on)
        .css('cursor', on ? 'pointer' : 'default');
      if (on) {
        button
          .attr('title', toolTip(newTag))
          .unbind('click')
          .bind('click', function() { show(newTag); });
      }
    };

    //---------------------------------------------------
    // < avatar >
    //---------------------------------------------------

    var makeAvatarNavigationHtml = function() {
      return '<table class="navigate-control">' +
               '<tr valign="top">' +
                 td('right',  makeAvatarButtonHtml('prev')) +
                 td('center', makeAvatarImageHtml()) +
                 td('left',   makeAvatarButtonHtml('next')) +
               '</tr>' +
             '</table>';
    };

    //- - - - - - - - - - - - - - -

    var makeAvatarButtonHtml = function(direction) {
      return '<button id="' + direction + '-avatar">' +
                '<img src="/images/triangle_' + direction +'.gif"/>' +
             '</button>';
    };

    //- - - - - - - - - - - - - - -

    var makeAvatarImageHtml = function() {
      return '<img id="avatar"' +
                ' src="/images/avatars/' + avatarName + '.jpg"/>';
    };

    //- - - - - - - - - - - - - - -
    // refresh < avatar >
    //- - - - - - - - - - - - - - -

    var refreshAvatarImage = function() {
      $('#avatar').parent().html(makeAvatarImageHtml());
    };

    //- - - - - - - - - - - - - - -

    var refreshPrevAvatarHandler = function() {
      refreshAvatarHandler('prev', data.prevAvatar);
    };

    //- - - - - - - - - - - - - - -

    var refreshNextAvatarHandler = function() {
      refreshAvatarHandler('next', data.nextAvatar);
    };

    //- - - - - - - - - - - - - - -

    var refreshAvatarHandler = function(id,name) {
      var title = function() {
        var text = 'Click to review ' + name + "'s ";
        return text + (inDiffMode() ? 'history diff' : 'current code');
      };
      $('#' + id + '-avatar')
        .attr('disabled', name === '')
        .attr('title', title())
        .unbind('click')
        .bind('click', function() {
          avatarName = name;
          if (inDiffMode()) {
            show(1);
          } else {
            showNoDiff();
          }
        });
    };

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    var show = function(tag) {
      data.wasTag = tag - (diffCheckBox().is(':checked') ? 1 : 0);
      data.nowTag = tag;
      refresh();
    };

    //- - - - - - - - - - - - - - -

    var showNoDiff = function() {
      var lastTag = -1;
      data.wasTag = lastTag;
      data.nowTag = lastTag;
      refresh();
    };

    //- - - - - - - - - - - - - - -

    var toolTip = function(tag) {
      if (inDiffMode()) {
        return 'Show diff->' + tag;
      } else {
        return 'Show ' + tag;
      }
    };

    //---------------------------------------------------
    // diff Div
    //---------------------------------------------------

    var makeDiffDiv = function()  {
      var div = $('<div>', {
        'id': 'history-dialog'
      });
      div.append(
          '<table>' +
            '<tr valign="top">' +
              '<td><div id="diff-content"></div></td>' +
              '<td><div id="diff-filenames"></div></td>' +
            '</tr>' +
          '</table>');
      return div;
    };

    var diffDiv = makeDiffDiv();

    var refreshDiff = function() {
      diffFilenames.html(makeDiffFilenames(data.diffs));
      resetFilenameAddedDeletedLineCountHandlers();
      diffContent.html(makeDiffContent(data.diffs));
      buildDiffFilenameHandlers(data.idsAndSectionCounts);
      showFile(data.currentFilenameId);
    };

    var showFile = function(filenameId) {
      var filename =  $('#radio_' + filenameId, diffDiv);
      filename.click();
      filename.scrollIntoView({ direction: 'vertical' });
    };

    var diffContent = $('#diff-content', diffDiv);

    var makeDiffContent = function(diffs) {
      var holder = $('<span>');
      $.each(diffs, function(_, diff) {
        var table = $('' +
          '<div id="' + diff.filename + '_diff_div" class="filename_div">' +
          '<table>' +
            '<tr class="valign-top">' +
              cd.td('<div class="diff-line-numbers"></div>') +
              cd.td('<div id="diff_file_content_for_' + diff.filename +
              '" class="diff-sheet">' +
                '</div>') +
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
            previousFilenameNode !== undefined &&
            getFilename(previousFilenameNode) === filename;

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
            var downFromTop = 250;
            var halfSecond = 500;
            diffSheet.animate({
              scrollTop: '+=' + (section.offset().top - downFromTop) + 'px'
              }, halfSecond);
            sectionIndex += 1;
            sectionIndex %= sectionCount;
          }
          alreadyOpened.push(filename);
        };
      }; // loadFrom()

      $.each(diffs, function(_n, diff) {
        var filename = $('#radio_' + diff.id, diffDiv);
        filename.click(loadFrom(diff));
      });
    }; // buildDiffFilenameHandlers()

    //- - - - - - - - - - - - - - - - - - - - - - - - - -

    var diffFilenames = $('#diff-filenames', diffDiv);

    var makeDiffFilenames = function(diffs) {

      var table= $('<table>');
      $.each(diffs, function(_, diff) {
        var tr = $('<tr>');
        var td = $('<td>', { 'class': 'align-right' });

        var filenameDiv =
          $('<div>', {
              'class': 'filename',
              'id': 'radio_' + diff.id,
              'text': diff.filename
          });

        var noneOrSome = function(property) {
          return (diff[property] === 0) ? 'none' : 'some';
        };

        var deletedLineCountDiv = $('<div>', {
          'class': 'diff-deleted-line-count ' +
                    noneOrSome('deleted_line_count') +
                    ' button',
          'data-filename': diff.filename
        });

        var addedLineCountDiv = $('<div>', {
          'class': 'diff-added-line-count ' +
                   noneOrSome('added_line_count') +
                   ' button',
          'data-filename': diff.filename
        });

        if (diff.deleted_line_count > 0) {
          deletedLineCountDiv.append(diff.deleted_line_count);
        }
        if (diff.added_line_count > 0) {
          addedLineCountDiv.append(diff.added_line_count);
        }

        td.append(filenameDiv);
        if (diffCheckBox().is(':checked')) {
          tr.append($('<td>').append(deletedLineCountDiv));
          tr.append($('<td>').append(addedLineCountDiv));
        }
        tr.append(td);
        table.append(tr);
      });

      return table.html();
    };

    //- - - - - - - - - - - - -

    var resetFilenameAddedDeletedLineCountHandlers = function() {

      var display = function(node, name, value) {
        if ($(node).attr('disabled') !== 'disabled') {
          var filename = $(node).data('filename');
          var selector = '[id="' + filename + '_diff_div"] ' + name;
          $(selector, diffDiv).css('display', value);
        }
      };

      $('.diff-deleted-line-count', diffDiv)
        .clickToggle(
          function() { display(this, 'deleted', 'none' ); },
          function() { display(this, 'deleted', 'block'); }
        );

      $('.diff-added-line-count', diffDiv)
        .clickToggle(
          function() { display(this, 'added', 'none' ); },
          function() { display(this, 'added', 'block'); }
        );
    };

    //---------------------------------------------------
    // buttons: help fork revert close
    //---------------------------------------------------

    var makeAllButtons = function() {
      var buttons = [ ];
      var makeButton = function(name,handler) {
        return {
          text: name,
          'class': 'history-button',
          click: handler
        };
      };
      buttons.push(makeButton('help', function() {
        var url = 'http://blog.cyber-dojo.org/';
        url += '2014/10/the-cyber-dojo-history-dialog.html';
        window.open(url, '_blank');
      }));
      buttons.push(makeButton('fork', function() {
        doFork();
      }));
      if (showRevert) {
        buttons.push(makeButton('revert', function() {
          doRevert();
          historyDialog.remove();
        }));
      }
      buttons.push(makeButton('close', function() {
        historyDialog.remove();
      }));
      return buttons;
    };

    var forkButton = function() {
      return $('.ui-dialog-buttonset :nth-child(2) :first-child');
    };

    var revertButton = function() {
      return $('.ui-dialog-buttonset :nth-child(3) :first-child');
    };

    //- - - - - - - - - - - - - - -
    // dialog
    //- - - - - - - - - - - - - - -

    var historyDialog = diffDiv.dialog({
      title: cd.dialogTitle(makeTitleHtml()),
      width: 1045,
      modal: true,
      buttons: makeAllButtons(),
      autoOpen: false,
      open: function() { refresh(); },
      closeOnEscape: true,
      close: function() { $(this).remove(); },
    });

    //---------------------------------------------------
    // refresh
    //---------------------------------------------------

    var refresh = function() {
      $('.ui-dialog').addClass('busy');
      $.getJSON('/differ/diff',
        {
          id: id,
          avatar: avatarName,
          was_tag: wasTag(),
          now_tag: nowTag(),
          current_filename: currentFilename
        },
        function(historyData) {
          $('.ui-dialog').removeClass('busy');
          data = historyData;
          refreshDiffCheckBox();
          refreshTrafficLights();
          refreshDiff();
          refreshTagControls();
          refreshPrevAvatarHandler();
          refreshAvatarImage();
          refreshNextAvatarHandler();
          refreshRevertButton();
          refreshForkButton();
          var light = $('img[src$="_bar.png"]', titleBar());
          var options = { direction: 'horizontal', duration: 'slow' };
          light.scrollIntoView(options);
        }
      );
    };

    //---------------------------------------------------
    // fork button
    //---------------------------------------------------

    var makeForkButtonHtml = function() {
      return 'fork from ' + nowTag();
    };

    var refreshForkButton = function() {
      forkButton().html(makeForkButtonHtml());
    };

    //---------------------------------------------------
    // revert button
    //---------------------------------------------------

    var makeRevertButtonHtml = function() {
      return 'revert to ' + nowTag();
    };

    var refreshRevertButton = function() {
      if (showRevert) {
        revertButton().html(makeRevertButtonHtml());
      }
    };

    //---------------------------------------------------
    // doRevert()
    //---------------------------------------------------

    var doRevert = function() {
      $.getJSON('/reverter/revert', {
        id: id,
        avatar: avatarName,
        tag: nowTag()
      },
      function(data) {
        deleteAllCurrentFiles();
        copyRevertFilesToCurrentFiles(data.visibleFiles);
        $('#test-button').click();
      });
    };

    //- - - - - - - - - - - - - - -

    var deleteAllCurrentFiles = function() {
      $.each(cd.filenames(), function(_, filename) {
        if (filename !== 'output') {
          cd.doDelete(filename);
        }
      });
    };

    //- - - - - - - - - - - - - - -

    var copyRevertFilesToCurrentFiles = function(visibleFiles) {
      var filename;
      for (filename in visibleFiles) {
        if (filename !== 'output') {
          cd.newFileContent(filename, visibleFiles[filename]);
        }
      }
    };

    //---------------------------------------------------
    // doFork()
    //---------------------------------------------------

    var doFork = function() {
      $.getJSON('/forker/fork', {
        id: id,
        avatar: avatarName,
        tag: nowTag()
      },
      function(data) {
        if (data.forked) {
          forkSucceededDialog(data);
        } else {
          forkFailedDialog(data);
        }
      });
    };

    //- - - - - - - - - - - - - - -

    var forkSucceededDialog = function(fork) {
      var html = '' +
          "<div style='font-size:1.5em;'>" +
            "your forked dojo's id is&nbsp;" +
                fork.id.substring(0,6) +
          "</div>";
      var succeeded =
        $('<div>')
          .html(html)
          .dialog({
            autoOpen: false,
            modal: true,
            width: 250,
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
      var html = "" +
        "<div class='dialog'>" +
          "<div class='panel' style='font-size:1em;'>" +
              "On the originating server, " + data.reason + " " + data[data.reason] + " does not exist" +
          "</div>" +
        "</div>";
      var failed =
        $('<div>')
        .html(html)
        .dialog({
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

    //- - - - - - - - - - - - - - -

    historyDialog.dialog('open');

  };// dialog_history()

  return cd;

})(cyberDojo || {}, $);
