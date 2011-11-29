
function buildDiffFilenames(diffs) 
{
  var diffSheet = $j('#diff_sheet');
  var EDITOR_TAB_INDEX = 0;
  var diffTabs = $j('#diff_tabs');

  diffSheet.save = function() { };

  var loadFrom = function(filename, diffedLines, save) {
    return function() {
      diffSheet.save();
      diffTabs.tabs('select', EDITOR_TAB_INDEX);
      diffSheet.html(diffedLines);
      diffSheet.scrollTop(filename.attr('scrollTop'));
      diffSheet.scrollLeft(filename.attr('scrollLeft'));
      diffSheet.save = save;
      filename.toggleClass('selected');
    };
  };

  var saveTo = function(filename) {
    return function() {
      filename.attr('scrollTop', diffSheet.scrollTop());
      filename.attr('scrollLeft', diffSheet.scrollLeft());
      filename.toggleClass('selected');
    };
  };
  
  $j.each(diffs, function(n,diff) {
    var filename = $j('#' + diff.id);
    filename.click( loadFrom(filename, diff.content, saveTo(filename)) );
    filename.attr('scrollTop', 0);
    filename.attr('scrollLeft', 0);  
  });
}
