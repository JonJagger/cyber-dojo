/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Builds the diff filenames click handlers for a given kata-id,
  // given animal-name, and given traffic-light number. Clicking
  // on the filename brings it into view by hiding the previous
  // one and showing the selected one.
  
  cd.buildDiffFilenameHandlers = function(diffs) {
    
    // The section scrolling won't work.
    // Now each diff-view file has its own pair of divs
    // (one for the line-numbers and one for the content)
    // I need to target the specific divs with a '#id'
    // selector rather than via '.class'
    
    //var diffSheet = $('.diff_sheet');
    var diffContainer = $('#diff_files_container');
    
    var previousFilename;
    
    var loadFrom = function(filename, diff) {
      // filename is a dom node
      // diff is a data structure
      // TODO: Refactor...  filename.val() == diff[:name]
      //  diff[:filename] is better
      
      //var diffSheet = cd.fileContentFor(filename.val());
      var sectionIndex = 0;
      var sectionCount = diff.section_count;
      var id = diff.id;
      
      if (sectionCount > 0) {
          filename.parent().attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {        
        if (previousFilename !== undefined) {
          cd.fileDiv(previousFilename.val()).hide();          
        }
        cd.fileDiv(filename.val()).show();

        cd.radioEntrySwitch(previousFilename, filename);
        previousFilename = filename;
        // some files have no diffs
        if (sectionCount > 0) {
          var section = $('#' + id + '_section_' + sectionIndex);           
          var downFromTop = 100;
          var halfSecond = 500;
          //diffSheet.animate({
          diffContainer.animate({
            scrollTop: section.offset().top - diffContainer.offset().top - downFromTop
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

