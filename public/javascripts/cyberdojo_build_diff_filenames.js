
function build_diff_filenames(diffs) 
{
  var diff_sheet = $j('#diff_sheet');
  var EDITOR_TAB_INDEX = 0;
  var diff_tabs = $j('#diff_tabs');

  diff_sheet.save = function() { };

  var load_from = function(filename, diffed_lines, save) {
    return function() {
      diff_sheet.save();
      diff_tabs.tabs('select', EDITOR_TAB_INDEX);
      diff_sheet.html(diffed_lines);
      diff_sheet.scrollTop(filename.attr('scroll_top'));
      diff_sheet.scrollLeft(filename.attr('scroll_left'));
      diff_sheet.save = save;
      filename.toggleClass('selected');
    };
  };

  var save_to = function(filename) {
    return function() {
      filename.attr('scroll_top', diff_sheet.scrollTop());
      filename.attr('scroll_left', diff_sheet.scrollLeft());
      filename.toggleClass('selected');
    };
  };
  
  $j.each(diffs, function(n,diff) {
    var filename = $j('#' + diff.id);
    filename.click( load_from(filename, diff.content, save_to(filename)) );
    filename.attr('scroll_top', 0);
    filename.attr('scroll_left', 0);  
  });
}
