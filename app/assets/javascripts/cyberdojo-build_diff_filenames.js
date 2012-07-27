/*jsl:option explicit*/

//1. check tests still pass

var cyberDojo = (function($cd, $j) {

  $cd.buildDiffFilenames = function(diffs) {
    var diffSheet = $j('#diff_sheet');
    var diffPanel = $j('#diff_panel');
  
    diffSheet.toggle = function() { };
  
    var loadFrom = function(filename, diff, toggle) {
      var section_index = 0;
      var section_count = diff.section_count;
      return function() {
        diffSheet.toggle();
        diffSheet.html(diff.content);
        diffSheet.toggle = toggle;
        $j('div[class="filename"]').each(function() {
          $cd.deselectRadioEntry($j(this));
        });
        $cd.selectRadioEntry(filename);        
        if (section_count > 0) {
          var id = diff.name.replace(/\./g, '_');
          var pos = $j('#' + id + '_section_' + section_index).offset();
          section_index += 1;
          section_index %= section_count;
          diffPanel.animate({ scrollTop:  pos.top - 80 }, 500 );
        }        
      };
    };
  
    var toggleSelected = function(filename) {
      return function() {
        filename.toggleClass('selected');
      };
    };
    
    $j.each(diffs, function(n, diff) {
      var filename = $j('#radio_' + diff.id);
      filename.parent().click( loadFrom(filename, diff, toggleSelected(filename)) );
      if (diff.section_count > 0) {
        filename.parent().attr('title', 'reclick to cycle through diffs');
      }
    });
  };

  return $cd;
})(cyberDojo || {}, $);

