/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  // Builds the diff filename click handlers for a given kata-id,
  // given animal-name, and given traffic-light was/now numbers.
  // Clicking on the filename brings it into view by hiding the
  // previous one and showing the selected one.
  //
  // The first time the filename for a file with one or more diff-sections
  // is clicked the first diff-section is scrolled into view.
  //
  // Subsequent times if you click on the filename you will _not_ get
  // an autoscroll. The reason for this is so that the scrollPos of a
  // diff that has been manually scrolled is retained.
  //
  // However, if filename X is open and you reclick on the filename
  // then you _will_ get an autoscroll to the _next_ diff-section in that
  // diff (which will cycle round).
  
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
    
    var loadFrom = function(filename, filenameNode, id, sectionCount) {
      
      var diffSheet = cd.fileContentFor(filename);
      var sectionIndex = 0;
      
      if (sectionCount > 0) {
          filenameNode.parent().attr('title', 'Auto-scroll through diffs');
      }
      
      return function() {
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
    
    $.each(diffs, function(_n, diff) {
      var filenameNode = $('#radio_' + diff.id);
      var filename = filenameNode.val();
      filenameNode.parent().click(loadFrom(filename, filenameNode, diff.id, diff.section_count));
      bindLineNumbers(filename);
    });
  };

  return cd;
})(cyberDojo || {}, $);

