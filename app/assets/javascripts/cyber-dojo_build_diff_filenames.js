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
    var alreadyOpened = [ ];
    
    var loadFrom = function(filenameNode, id, sectionCount) {
      
      var diffSheet = cd.fileContentFor(filenameNode.val());
      var sectionIndex = 0;
      
      if (sectionCount > 0) {
          filenameNode.parent().attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {
        var filename = filenameNode.val();
        var reselected =
          previousFilenameNode !== undefined && previousFilenameNode.val() === filename;
        
        cd.radioEntrySwitch(previousFilenameNode, filenameNode);
        if (previousFilenameNode !== undefined) {
          cd.fileDiv(previousFilenameNode.val()).hide();          
        }
        cd.fileDiv(filenameNode.val()).show();
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
    
    $.each(diffs, function(n, diff) {
      // _filenames.html.erb contains an
      // <input id="radio_<%= diff[:id] %>" ... />
      // for each file in the current diff.
      var filenameNode = $('#radio_' + diff.id);
      filenameNode.parent().click(loadFrom(filenameNode, diff.id, diff.section_count));
      // assert filenameNode.val() == diff.filename
      bindLineNumbers(diff.filename);
    });
  };

  return cd;
})(cyberDojo || {}, $);

