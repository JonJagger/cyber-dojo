
var $cd = cyberDojo;

TestCase("cyberdojo-Test", {
  
  "test random3() returns 3 char string": function() {
    var target = $cd.random3();
    assert(typeof target === 'string');
    assertEquals(3, target.length);
  },
  
  "test randomChar() returns all chars from alphabet": function() {
    var generated = '';
    for (var n = 0; n != 1000; n++) {
        generated += $cd.randomChar();
    }
    var alphabet = $cd.randomAlphabet();
    for (var n = 0; n != alphabet.length; n++) {
        var ch = alphabet.charAt(n);
        assertNotEquals(-1, generated.indexOf(ch,0));
    }
  },
  
  "test filenames() finds all filenames": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    assertEquals(['cyberdojo.sh', 'instructions'], $cd.filenames());
  },
  
  "test fileAlreadyExists(file) returns true when file exists and false when file doesn't": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh"></textarea>
        <textarea id="file_content_for_instructions"></textarea>
      </div>
    */
    assert($cd.fileAlreadyExists('cyberdojo.sh'));    
    assert(!$cd.fileAlreadyExists('not.present'));    
  },
  
  "test sortFilenames() sorts filenames into ascending order": function() {
    var filenames = [ 'a', 'z', 's']
    filenames.sort();
    var expected = [ 'a', 's', 'z' ]
    assertEquals(expected, filenames);
  },
  
  "test currentFilename() finds file in filelist that is selected": function() {
    /*:DOC +=
      <div>
        <div class="filename" current_file="false">
          <input name="filename" type="radio" value="toy.story"/>
        </div>
        <div class="filename" current_file="true">
          <input name="filename" type="radio" value="randy_newman.txt" checked="checked"/>
        </div>
        
        <input type="hidden" name="current_filename" id="current_filename"
               value="randy_newman.txt"/>        
      </div>
    */
    assertEquals('randy_newman.txt', $cd.currentFilename());
    $cd.selectFileInFileList('toy.story');
    assertEquals('toy.story', $cd.currentFilename());
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
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                
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
    var space = ' ';
    assertEquals(space + 'omd', label.html());
  },
  
  "test makeNewFile()": function() {
    var hi = $cd.makeNewFile('its.name', 'its.content');
    assertEquals('filename_div', hi.attr('class'));
    assertEquals('its.name', hi.attr('name'));
    assertEquals('its.name_div', hi.attr('id'));
  },
  
  "test doDelete() deletes file from filelist": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                        
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
  
  "test deleteFilePrompt(false)": function() {
    /*:DOC +=
      <div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                                
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
    $cd.deleteFilePrompt(false);
    assertEquals(['A', 'C'], $cd.filenames());
    assertTrue($cd.currentFilename() == 'A' || $cd.currentFilename() == 'C');    
  },
  
  "test newFileContent":function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                                        
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
    assertEquals(['A', 'B', 'C'], $cd.filenames());

    var filename = 'D';
    var content = 'dddd';
    $cd.newFileContent(filename,content);
    assertEquals('dddd', $cd.fileContentFor('D').attr('value'));
    assertEquals(['A', 'B', 'C', 'D'], $cd.filenames());    
  },
  
  "test rebuildFilenameList() after adding a filename": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="A"/>                                        
        <div id="visible_files_container">
          <div id="A_div">
            <textarea id="file_content_for_A">aaaaaaaaaaa</textarea>
          </div>
        </div>        
      </div>
    */
    assertEquals(1, $cd.filenames().length);
    var filenames = $cd.rebuildFilenameList();
    
    var filename = 'D';
    var content = 'dddd';
    $cd.newFileContent(filename,content);
    filenames = $cd.rebuildFilenameList();
    assertEquals(2, filenames.length);
    assertEquals(['A','D'], filenames.sort());
  },
  
  "test rebuildFilenameList() after removing a filename": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                                                
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
  
  "test renameFileFromTo()": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <input type="hidden" name="current_filename" id="current_filename"
               value="B"/>                                                        
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
    var oldFilename = 'B';
    var oldContent = $cd.fileContentFor(oldFilename);
    assertEquals(['A', oldFilename, 'C'], $cd.filenames());
    assertEquals(oldFilename, $cd.currentFilename());
    var newFilename = 'BB';
    $cd.renameFileFromTo(oldFilename, newFilename);
    assertEquals(['A', newFilename, 'C'], $cd.filenames().sort());
    assertEquals(newFilename, $cd.currentFilename());
  },
  
});
