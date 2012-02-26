
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
          $j(this).css('background-color', '#B2EFEF');
          $j(this).css('color', '#777');
        });
        filename.parent().css('background-color', 'Cornsilk');
        filename.parent().css('color', 'DarkGreen');
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

