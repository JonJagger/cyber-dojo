/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Builds the diff filename click handlers for a given kata-id,
  // given animal-name, and given traffic-light was/now numbers.
  // Clicking on the filename brings it into view by hiding the
  // previously selected file and showing the selected one.
  //
  // The first time the filename for a file with one or more diff-sections
  // is clicked its diff-section is scrolled into view.
  //
  // Subsequent times if you click on the filename you will _not_ get
  // an autoscroll. The reason for this is so that the scrollPos of a
  // diff that has been manually scrolled is retained.
  //
  // However, if filename X is open and you reclick on filename X
  // then you _will_ get an autoscroll to the _next_ diff-section in that
  // diff (which will cycle round).
  
  cd.buildDiffFilenameHandlers = function(diffs) {

    var previousFilenameNode;
    var alreadyOpened = [ ];
    var getFilename = function(node) {
      return $.trim(node.text());
    };
    
    var loadFrom = function(filename, filenameNode, id, sectionCount) {
      
      var diffSheet = cd.fileContentFor(filename);
      var sectionIndex = 0;
      
      if (sectionCount > 0) {
          filenameNode.attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {
        var reselected =
          previousFilenameNode !== undefined && getFilename(previousFilenameNode) === filename;
        
        cd.radioEntrySwitch(previousFilenameNode, filenameNode);
        if (previousFilenameNode !== undefined) {
          cd.fileDiv(getFilename(previousFilenameNode)).hide();          
        }
        cd.fileDiv(getFilename(filenameNode)).show();
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
      cd.bindLineNumbersEvents(filename);
    });
  };

  return cd;
})(cyberDojo || {}, $);

