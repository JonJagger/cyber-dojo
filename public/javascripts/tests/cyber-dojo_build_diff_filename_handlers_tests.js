
var $cd = cyberDojo;

TestCase("cyber-dojo_build_diff_filename_handers_tests", {
  
  "test": function() {
    /*:DOC +=
      <div id="diff_panel">
        <div id="diff_sheet">
        </div>
      </div>
      <div>
        <div>
          <div id="234" lass="filename">
            <input id="radio_234" name="filename" type="radio" value="A"/>
            <label>234</label>
          </div>
          <div id="987" class="filename">          
            <input id="radio_987" name="filename" type="radio" value="B" checked="checked"/>
            <label>987</label>
          </div>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>
      </div>      
    */
    var content = '<div id="234_section_0">content-for-234</div>';
    var diffs =
    [
      {
        id: '234',
        section_count: 1,
        content: content
      },
      {
        id: '987',
        section_count: 0,
        content: 'content-for-987'
      }
    ];
    $cd.buildDiffFilenameHandlers(diffs);

    $('#radio_234').parent().click();    
    assertEquals( content , $('#diff_sheet').html());
  },
  
});
