/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  // diffs for a given kata-id, given animal-name, and given traffic-light-number
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
    
    // The filename list is loaded via
    // app/views/diff/_filenames.html.erb and starts <% @diffs.each do |file| -%>
    // relies on file[:id]  with :id created as follows...
    // (in lib/GitDiff.rb)
    //
    // n = 0
    // diffs = [ ]
    // diffed_files.sort.each do |name,diff|    
    //    n += 1
    //    id = 'jj' + n.to_s
    //    diffs << {  :id => id }
    // end
    //
    // A self-contained diff-view of a complete dojo will need a
    // prefix of (rather than'jj') the kata id (8 hex digits)
    // concatenated with the animal-name
    // concatenated with the traffic-light increment-number.
    // These are the three bits of info gotten from
    // app/views/diff/show.html.erb
    //    id: "<%= @kata.id -%>",
    //    avatar: "<%= @avatar.name -%>",
    //    tag: "<%= @traffic_lights_to_tag.length -%>"
    //

    $j.each(diffs, function(n, diff) {
      // _filenames.html.erb contains an <input type="radio" id="radio_<%=diff[:id]-%>" />
      // for each file in the current diff.
      var filename = $j('#radio_' + diff.id);
      filename.parent().click( loadFrom(filename, diff, toggleSelected(filename)) );
      if (diff.section_count > 0) {
        filename.parent().attr('title', 'reclick to cycle through diffs');
      }
    });
  };

  return $cd;
})(cyberDojo || {}, $);

