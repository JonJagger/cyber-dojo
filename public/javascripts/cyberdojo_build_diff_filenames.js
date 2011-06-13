
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
  
  for (var i = 0; i != diffs.length; i++) {
    var filename = $j('#' + diffs[i].id);
    filename.click( load_from(filename, diffs[i].content, save_to(filename)) );
    filename.attr('scroll_top', 0);
    filename.attr('scroll_left', 0);
  }  
}

