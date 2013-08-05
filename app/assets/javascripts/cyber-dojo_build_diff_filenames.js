/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Builds the diff filenames click handlers for a given kata-id,
  // given animal-name, and given traffic-light number. Clicking
  // on the filename brings its diff into view by loading it into
  // the diffSheet.
  
  cd.buildDiffFilenameHandlers = function(diffs) {
    var diffLineNumbers = $('#diff_line_numbers');
    var diffSheet = $('#diff_sheet');
    var diffPanel = $('#diff_panel');  
    var previousFilename;
    
    var loadFrom = function(filename, diff) {
      var sectionIndex = 0;
      var sectionCount = diff.section_count;
      var id = diff.id;
      
      if (sectionCount > 0) {
          filename.parent().attr('title', 'Auto-scroll through diffs');
      }
      return function() {
        diffLineNumbers.html(diff.line_numbers);
        diffSheet.html(diff.content);
        cd.radioEntrySwitch(previousFilename, filename);
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
    });
  };

  return cd;
})(cyberDojo || {}, $);

