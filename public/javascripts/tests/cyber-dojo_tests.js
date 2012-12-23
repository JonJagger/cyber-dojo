
var $cd = cyberDojo;

TestCase("cyber-dojo_tests", {
  
  "test filenames() finds all filenames": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    assertEquals(['cyberdojo.sh', 'instructions'], $cd.filenames());
  },
  
  "test filenameAlreadyExists() returns true when visible filename exists": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    $cd.supportFilenames = function() { return [ ]; };
    $cd.hiddenFilenames = function() { return [ ]; };    
    assert($cd.filenameAlreadyExists('cyberdojo.sh'));    
  },
  
  "test filenameAlreadyExists() returns true when hidden filename exists": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    $cd.supportFilenames = function() { return [ ]; };
    var hiddenFilename = 'catch.hpp';
    $cd.hiddenFilenames = function() { return [ hiddenFilename ]; };    
    assert($cd.filenameAlreadyExists(hiddenFilename));    
  },
  
  "test filenameAlreadyExists() returns true when support filename exists": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    var supportFilename = 'nunit.core.dll';
    $cd.supportFilenames = function() { return [ supportFilename ]; };
    $cd.hiddenFilenames = function() { return [ ]; };    
    assert($cd.filenameAlreadyExists(supportFilename));    
  },

  "test filenameAlreadyExists() returns false when filename doesn't exist": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    $cd.supportFilenames = function() { return [ ]; };
    $cd.hiddenFilenames = function() { return [ ]; };    
    assert(!$cd.filenameAlreadyExists('not.present'));    
  },

  "test sortFilenames() sorts filenames into ascending order": function() {
    var filenames = [ 'a', 'z', 's']
    filenames.sort();
    var expected = [ 'a', 's', 'z' ]
    assertEquals(expected, filenames);
  },
  
  "test currentFilename() finds file in filelist that is loaded": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>
        <div>
          <textarea id="file_content_for_A">a</textarea>
          <textarea id="file_content_for_B">b</textarea>
        </div>        
      </div>
    */
    assertEquals('B', $cd.currentFilename());
    $cd.loadFile('A');
    assertEquals('A', $cd.currentFilename());
  },
  
  "test fileContentFor() retrieves dom node": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_A">src</textarea>
      </div>
    */
    assertEquals('src', $cd.fileContentFor('A').attr('value'));
  },
  
  "test loadNextFile() rotates through all files in filelist": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>        
        <div>
          <textarea id="file_content_for_A">a</textarea>
          <textarea id="file_content_for_B">b</textarea>
          <textarea id="file_content_for_C">c</textarea>
        </div>
      </div>
    */
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    assertEquals('B', $cd.currentFilename());
    $cd.loadNextFile();
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    assertEquals('C', $cd.currentFilename());
    $cd.loadNextFile();
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    assertEquals('A', $cd.currentFilename());
    $cd.loadNextFile();
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    assertEquals('B', $cd.currentFilename());
  },
  
  "test makeFileListEntry()": function() {
    var entry = $cd.makeFileListEntry('omd');
    assertFunction(entry.click);
    var input = entry.contents('input');
    assertEquals(1, input.length);
    assertEquals('radio_omd', input.attr('id'));
    assertEquals('filename', input.attr('name'));
    assertEquals('radio', input.attr('type'));
    assertEquals('omd', input.attr('value'));
    var label = entry.children('label');
    assertEquals(1, label.length);
    assertEquals('omd', label.html());
  },
  
  "test makeNewFile()": function() {
    $cd.tabExpansion = function() { return "  "; };
    var hi = $cd.makeNewFile('its.name', 'its.content');
    assertEquals('filename_div', hi.attr('class'));
    assertEquals('its.name', hi.attr('name'));
    assertEquals('its.name_div', hi.attr('id'));
  },
  
  "test newFile()": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div id="visible_files_container">
          <div id="A_div">        
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>        
          <div id="B_div">        
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>        
          <div id="C_div">        
            <textarea id="file_content_for_C">ccccccccccc</textarea>
          </div>        
        </div>        
      </div>
    */    
    $cd.newFile();
  },
  
  "test doDelete() deletes file from filelist": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div>
          <div id="A_div">
            <textarea id="file_content_for_A"></textarea>
          </div>
          <div id="B_div">          
            <textarea id="file_content_for_B"></textarea>
          </div>
          <div id="C_div">            
            <textarea id="file_content_for_C"></textarea>
          </div>
        </div>
      </div>
    */
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    var filename = 'B';
    assertEquals(filename, $cd.currentFilename());
    $cd.doDelete('B');
    assertEquals(['A', 'C'], $cd.filenames());
    assertTrue($cd.currentFilename() == 'A' || $cd.currentFilename() == 'C');
  },
  
  "test deleteFilePrompt(avatarName, ask=false)": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div>
          <div id="A_div">        
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>
          <div id="B_div">
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>
          <div id="C_div">
            <textarea id="file_content_for_C">ccccccccccc</textarea>
          </div>
        </div>
      </div>
    */
    assertEquals(['A', 'B', 'C'], $cd.filenames());
    var filename = 'B';
    assertEquals(filename, $cd.currentFilename());
    var avatarName,ask;
    $cd.deleteFilePrompt(avatarName = 'snake', ask = false);
    assertEquals(['A', 'C'], $cd.filenames());
    assertTrue($cd.currentFilename() == 'A' || $cd.currentFilename() == 'C');    
  },
  
  "test deleteFilePrompt(avatarName, ask=true)": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
        </div>      
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>
        <div>
          <div id="B_div">
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>
        </div>
      </div>
    */    
    var avatarName,ask;
    $cd.deleteFilePrompt(avatarName = 'snake', ask = true);    
  },
  
  "test newFileContent":function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div id="visible_files_container">
          <div id="A_div">        
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>        
          <div id="B_div">        
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>        
          <div id="C_div">        
            <textarea id="file_content_for_C">ccccccccccc</textarea>
          </div>        
        </div>        
      </div>
    */
    $cd.tabExpansion = function() { return "  "; };    
    assertEquals(['A', 'B', 'C'], $cd.filenames());

    var filename = 'D';
    var content = 'dddd';
    $cd.newFileContent(filename, content);
    assertEquals('dddd', $cd.fileContentFor('D').attr('value'));
    assertEquals(['A', 'B', 'C', 'D'], $cd.filenames());    
  },
  
  "test rebuildFilenameList() after adding a filename": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div id="visible_files_container">
          <div id="A_div">
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>
          <div id="B_div">
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>
        </div>        
      </div>
    */
    $cd.tabExpansion = function() { return "  "; };    
    assertEquals(2, $cd.filenames().length);
    var filenames = $cd.rebuildFilenameList();
    
    var filename = 'C';
    var content = 'dddd';
    $cd.newFileContent(filename, content);
    var filenames = $cd.rebuildFilenameList();
    assertEquals(3, filenames.length);
    assertEquals(['A','B','C'], filenames.sort());
  },
  
  "test rebuildFilenameList() after removing a filename": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div id="visible_files_container">
          <div id="A_div">
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>
          <div id="B_div">
            <textarea id="file_content_for_B">bbbbbbbbbb</textarea>
          </div>
          <div id="C_div">
            <textarea id="file_content_for_C">ccccccccc</textarea>
          </div>
        </div>        
      </div>
    */
    assertEquals(3, $cd.filenames().length);
    assertEquals('B', $cd.currentFilename());
    $cd.deleteFilePrompt(false);
    
    var filenames = $cd.rebuildFilenameList();
    assertEquals(2, filenames.length);
    assertEquals(['A','C'], filenames.sort());
  },
  
  "test canRenameFileFromTo() is false when newFilename is empty string": function() {
    var oldFilename = 'any';
    var newFilename = '';
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));
  },
  
  "test canRenameFileFromTo() is false when newFilename equals oldFilename": function() {
    var oldFilename = 'same';
    var newFilename = 'same';
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));
  },
  
  "test canRenameFileFromTo() is false when newFilename already exists": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_A"></textarea>
        <textarea id="file_content_for_B"></textarea>
      </div>
    */
    var oldFilename = 'A';
    var newFilename = 'B';
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));
  },
  
  "test canRenameFileFromTo() is false when newFilename contains a back-slash": function() {
    var oldFilename = 'any';
    var newFilename = "no\\pe";
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));    
  },
  
  "test canRenameFileFromTo() is false when newFilename starts with a forward-slash": function() {
    var oldFilename = 'any';
    var newFilename = "//nope";
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));    
  },

  "test canRenameFileFromTo() is false when newFilename contains ..": function() {
    var oldFilename = 'any';
    var newFilename = "no..pe";
    assertEquals(false, $cd.canRenameFileFromTo('wolf', oldFilename, newFilename));    
  },

  "test renameFileFromTo()": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>                
        <div id="visible_files_container">
          <div id="A_div">
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>
          <div id="B_div">
            <textarea id="file_content_for_B">bbbbbbbbbbb</textarea>
          </div>
          <div id="C_div">
            <textarea id="file_content_for_C">ccccccccccc</textarea>
          </div>
        </div>        
      </div>
    */
    $cd.tabExpansion = function() { return "  "; };    
    var oldFilename = 'B';
    var oldContent = $cd.fileContentFor(oldFilename);
    assertEquals(['A', oldFilename, 'C'], $cd.filenames());
    assertEquals(oldFilename, $cd.currentFilename());
    var newFilename = 'BB';
    $cd.renameFileFromTo('frog', oldFilename, newFilename);
    assertEquals(['A', newFilename, 'C'], $cd.filenames().sort());
    assertEquals(newFilename, $cd.currentFilename());
  },
  
  "test renameFile()": function() {
    /*:DOC +=
      <div>
        <input type="hidden" name="current_filename" id="current_filename" value="B"/>
      </div>
    */    
    var avatarName = 'wolf';
    $cd.renameFile(avatarName);
  },
  
});
