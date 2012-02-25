
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
          $j(this).attr('current', 'false');
        });
        filename.parent().attr('current', 'true');
        filename.attr('checked', 'checked');
      };
    };
  
    var saveTo = function(filename) {
      return function() {
        filename.toggleClass('selected');
      };
    };
    
    $j.each(diffs, function(n, diff) {
      var filename = $j('#radio_' + diff.id);
      filename.parent().click( loadFrom(filename, diff.content, saveTo(filename)) );
    });
  };

  return $cd;
})(cyberDojo || {}, $j);

