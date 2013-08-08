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

    var previousFilename;
    
    var loadFrom = function(filename, diff) {
      // filename is a dom node
      // diff is a data structure
      // TODO: Refactor...  filename.val() == diff[:name]
      //  diff[:filename] is better
      
      var diffSheet = cd.fileContentFor(filename.val());
      var sectionIndex = 0;
      var sectionCount = diff.section_count;
      var id = diff.id;
      
      if (sectionCount > 0) {
          filename.parent().attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {        
        cd.radioEntrySwitch(previousFilename, filename);
        if (previousFilename !== undefined) {
          cd.fileDiv(previousFilename.val()).hide();          
        }
        cd.fileDiv(filename.val()).show();
        previousFilename = filename;
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
      var filename = $('#radio_' + diff.id);
      filename.parent().click(loadFrom(filename, diff));
      bindLineNumbers(filename.val());
    });
  };

  return cd;
})(cyberDojo || {}, $);

