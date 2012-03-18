/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.buildDiffFilenames = function(diffs) {
    var diffSheet = $j('#diff_sheet');
  
    diffSheet.toggle = function() { };
  
    var loadFrom = function(filename, diffedLines, toggle) {
      return function() {
        diffSheet.toggle();
        diffSheet.html(diffedLines);
        diffSheet.toggle = toggle;
        $j('div[class="filename"]').each(function() {
          $cd.deselectRadioEntry($j(this));
        });
        $cd.selectRadioEntry(filename);
      };
    };
  
    var toggleSelected = function(filename) {
      return function() {
        filename.toggleClass('selected');
      };
    };
    
    $j.each(diffs, function(n, diff) {
      var filename = $j('#radio_' + diff.id);
      filename.parent().click( loadFrom(filename, diff.content, toggleSelected(filename)) );
    });
  };

  return $cd;
})(cyberDojo || {}, $j);

