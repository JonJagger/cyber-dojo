
var cyberDojo = (function($cd, $j) {

  $cd.buildDiffFilenames = function(diffs) {
    var diffSheet = $j('#diff_sheet');
  
    diffSheet.save = function() { };
  
    var loadFrom = function(filename, diffedLines, save) {
      return function() {
        diffSheet.save();
        diffSheet.html(diffedLines);
        diffSheet.save = save;
        $j('div[class="filename"]').each(function() {
          $j(this).attr('current_file', 'false');
        });
        filename.attr('current_file', 'true');
        filename.toggleClass('selected');
      };
    };
  
    var saveTo = function(filename) {
      return function() {
        filename.toggleClass('selected');
      };
    };
    
    $j.each(diffs, function(n, diff) {
      var filename = $j('#' + diff.id);
      filename.click( loadFrom(filename, diff.content, saveTo(filename)) );
    });
  };

  return $cd;
})(cyberDojo || {}, $j);

