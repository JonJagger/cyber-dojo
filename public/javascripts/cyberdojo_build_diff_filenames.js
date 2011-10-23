
function build_diff_filenames(diffs) 
{
  var view = $j('#diff_sheet');

  view.save = function() { };

  var load_from = function(filename, diffed_lines, save) {
    return function() {
      view.save();
      view.html(diffed_lines);
      view.scrollTop(filename.attr('scroll_top'));
      view.scrollLeft(filename.attr('scroll_left'));
      view.save = save;
      filename.toggleClass('selected');
    };
  };

  var save_to = function(filename) {
    return function() {
      filename.attr('scroll_top', view.scrollTop());
      filename.attr('scroll_left', view.scrollLeft());
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
