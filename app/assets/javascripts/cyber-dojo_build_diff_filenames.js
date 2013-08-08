/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Builds the diff filenames click handlers for a given kata-id,
  // given animal-name, and given traffic-light number. Clicking
  // on the filename brings it into view by hiding the previous
  // one and showing the selected one.
  
  cd.buildDiffFilenameHandlers = function(diffs) {
    
    var bindLineNumbers = function(filename) {
      var content = cd.fileContentFor(filename);
      var numbers = cd.lineNumbersFor(filename);
      
      function setLine() {
        numbers.scrollTop(content.scrollTop());   
      }
      
      content.bind({
        keydown   : function(ev) { setLine(); },
        scroll    : function(ev) { setLine(); },
        mousewheel: function(ev) { setLine(); },
        mousemove : function(ev) { setLine(); },
        mousedown : function(ev) { setLine(); },
        mouseup   : function(ev) { setLine(); }
      });
    };

    var previousFilenameNode;
    
    var loadFrom = function(filenameNode, diff) {
      // assert filename.val() == diff[:filename]
      
      var diffSheet = cd.fileContentFor(filenameNode.val());
      var sectionIndex = 0;
      var sectionCount = diff.section_count;
      var id = diff.id;
      
      if (sectionCount > 0) {
          filenameNode.parent().attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {
        
        // .hide() and .show() calls restore the cursorPos and scrollPos
        // correctly (automatically) on files that have no diffs.
        // However, if the file has a diff it will auto-scroll to the
        // first diff-section (when opened) rather than leaving the
        // position where it was. This could be refactored so autoscroll
        // only happens when a file is selected for the first time
        // or when the current file is explicitly reselected.
        
        cd.radioEntrySwitch(previousFilenameNode, filenameNode);
        if (previousFilenameNode !== undefined) {
          cd.fileDiv(previousFilenameNode.val()).hide();          
        }
        cd.fileDiv(filenameNode.val()).show();
        previousFilenameNode = filenameNode;
        // some files have no diffs
        if (sectionCount > 0) {
          var section = $('#' + id + '_section_' + sectionIndex);           
          var downFromTop = 100;
          var halfSecond = 500;          
          diffSheet.animate({
            scrollTop: section.offset().top - diffSheet.offset().top - downFromTop
            }, halfSecond);
          sectionIndex += 1;
          sectionIndex %= sectionCount;
        }        
      };
    };
    
    $.each(diffs, function(n, diff) {
      // _filenames.html.erb contains an
      // <input type="radio" id="radio_<%= diff[:id] %>" />
      // for each file in the current diff.
      var filenameNode = $('#radio_' + diff.id);
      filenameNode.parent().click(loadFrom(filenameNode, diff));
      bindLineNumbers(diff.filename);
    });
  };

  return cd;
})(cyberDojo || {}, $);

