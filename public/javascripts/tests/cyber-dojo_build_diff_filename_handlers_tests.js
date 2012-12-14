
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
          <input id="radio_234" name="filename" type="radio" value="A"/>
          <input id="radio_987" name="filename" type="radio" value="B" checked="checked"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>
        <div>
          <textarea id="file_content_for_A">a</textarea>
          <textarea id="file_content_for_B">b</textarea>
        </div>        
      </div>      
    */    
    diffs =
    [
      {
        id: '234',
        section_count: 0,
        content: 'content-for-234'
      },
      {
        id: '987',
        section_count: 0,
        content: 'content-for-987'
      },
    ]
    $cd.buildDiffFilenameHandlers(diffs);
    //TODO: add diff with section_count > 0 and content has
    //      sections with appropriate ids.
    //TODO: get document, retrieve filename elements,
    //      simulate clicking them, test correct content
    //      is moved into diff_sheet
  },
  
});
