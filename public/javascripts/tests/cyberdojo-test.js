
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
        <input id="file_content_for_cyberdojo.sh"/>
        <input id="file_content_for_instructions"/>
      </div>
    */
    assertEquals(['cyberdojo.sh', 'instructions'], $cd.filenames());
  },
  "test fileAlreadyExists() returns true when it does and false when it doesn't": function() {
    /*:DOC +=
      <div>
        <input id="file_content_for_cyberdojo.sh"/>
        <input id="file_content_for_instructions"/>
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
        <input name="filename" type="radio" value="toy.story"/>
        <input name="filename" type="radio" value="randy_newman.txt" checked="checked"/>
      </div>
    */
    assertEquals('randy_newman.txt', $cd.currentFilename());
  },  
  "test fileContent() retrieves dom node": function() {
    /*:DOC +=
      <div>
        <input id="file_content_for_A" value="src"/>
      </div>
    */
    assertEquals('src', $cd.fileContent('A').attr('value'));
  },
  "test fileCaretPos() retrieves dom node": function() {
    /*:DOC +=
      <div>
        <input id="file_caret_pos_for_A" value="13"/>
      </div>
    */
    assertEquals('13', $cd.fileCaretPos('A').attr('value'));        
  },
  "test fileScrollTop() retrieves dom node": function() {
    /*:DOC +=
      <div>
        <input id="file_scroll_top_for_A" value="42"/>
      </div>
    */
    assertEquals('42', $cd.fileScrollTop('A').attr('value'));            
  },  
  "test fileScrollLeft() retrieves dom node": function() {
    /*:DOC +=
      <div>
        <input id="file_scroll_left_for_A" value="34"/>
      </div>
    */
    assertEquals('34', $cd.fileScrollLeft('A').attr('value'));            
  },
  "test loadNextFile() rotates through all files in filelist": function() {
    /*:DOC +=
      <div>
        <textarea id="editor"></textarea>
        <div>
          <input id="file_content_for_A" value="a"/>
          <input id="file_content_for_B" value="b"/>
          <input id="file_content_for_C" value="c"/>
        </div>
        <div>
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
        </div>
        <div>
          <input id="file_scroll_top_for_A" value="7"/>
          <input id="file_scroll_top_for_B" value="8"/>
          <input id="file_scroll_top_for_C" value="9"/>
        </div>        
        <div>
          <input id="file_scroll_left_for_A" value="4"/>
          <input id="file_scroll_left_for_B" value="5"/>
          <input id="file_scroll_left_for_C" value="6"/>
        </div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
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
  "test createHiddenInput()": function() {
    var hi = $cd.createHiddenInput('rem', 'caret_pos', 42);
    assertEquals('hidden', hi.attr('type'));
    assertEquals("file_caret_pos['rem']", hi.attr('name'));
    assertEquals('file_caret_pos_for_rem', hi.attr('id'));
    assertEquals('42', hi.attr('value'));
  },
  "test loadFile() sets editor content and selects it in filelist": function() {
    /*:DOC +=
      <div>
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>
        <div>
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>
          <input id="file_content_for_B" value="bbbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccccc"/>
        </div>
        <div>
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
        </div>
        <div>
          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>
        </div>        
        <div>
          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
        </div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>        
      </div>
    */
    var filename = 'C';    
    var editor = $j('#editor');    
    $j('#editor_tabs').tabs();
    $cd.loadFile(filename);
    assertEquals('ccccccccccc', editor.val());
    // NB: this fails in IE8
    //assertEquals(3, editor.caretPos());
    // NB: these two always fail...???
    //assertEquals(3, editor.scrollTop());
    //assertEquals(3, editor.scrollLeft());
    assertEquals(filename, $cd.currentFilename());
  },
  "test doDelete() deletes file from filelist": function() {
    /*:DOC +=
      <div>
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>
        <div>
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>
          <input id="file_content_for_B" value="bbbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccccc"/>
        </div>
        <div>
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
        </div>
        <div>
          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>
        </div>        
        <div>
          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
        </div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
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
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>
        <div>
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>
          <input id="file_content_for_B" value="bbbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccccc"/>
        </div>
        <div>
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
        </div>
        <div>
          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>
        </div>        
        <div>
          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
        </div>
        <div>
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
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
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>
        <div id="visible_files_container">
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>
          <input id="file_content_for_B" value="bbbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccccc"/>
          
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
          
          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>
          
          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
          
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>        
      </div>
    */
    assertEquals(['A', 'B', 'C'], $cd.filenames());

    var filename = 'D';
    var content = 'dddd';
    var caretPos = 1;
    var scrollTop = 2;
    var scrollLeft = 3;
    $cd.newFileContent(filename,content,caretPos,scrollTop,scrollLeft);
    assertEquals('dddd', $cd.fileContent('D').attr('value'));
    assertEquals(1, $cd.fileCaretPos('D').attr('value'));
    assertEquals(2, $cd.fileScrollTop('D').attr('value'));
    assertEquals(3, $cd.fileScrollLeft('D').attr('value'));
    assertEquals(['A', 'B', 'C', 'D'], $cd.filenames());    
  },
  
  "test rebuildFilenameList() after adding a filename": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
        </div>
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>        
        <div id="visible_files_container">
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>        
        </div>        
      </div>
    */
    assertEquals(1, $cd.filenames().length);
    var filenames = $cd.rebuildFilenameList();
    
    var filename = 'D';
    var content = 'dddd';
    var caretPos = 1;
    var scrollTop = 2;
    var scrollLeft = 3;
    $cd.newFileContent(filename,content,caretPos,scrollTop,scrollLeft);
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
        
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>        
        <div id="visible_files_container">
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>        
          <input id="file_content_for_B" value="bbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccc"/>
          
          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>
          
          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>
          
          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
        </div>        
      </div>
    */
    assertEquals(3, $cd.filenames().length);
    assertEquals('B', $cd.currentFilename());
    $cd.deleteFilePrompt(false);
    
    var filenames = $cd.rebuildFilenameList();
    assertEquals(2, filenames.length); // FAILS
    assertEquals(['A','C'], filenames.sort());
  },
  
  "test selectFileInFileList()": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <div id="current_filename" value="B"></div>
      </div>    
    */
    assertEquals('B', $cd.currentFilename());
    $cd.selectFileInFileList('C');
    assertEquals('C', $cd.currentFilename());    
  },

  "test renameFileFromTo()": function() {
    /*:DOC +=
      <div>
        <div id="filename_list">
          <input id="radio_A" name="filename" type="radio" value="A"/>
          <input id="radio_B" name="filename" type="radio" value="B" checked="checked"/>
          <input id="radio_C" name="filename" type="radio" value="C"/>
        </div>
        <div id="current_filename" value="B"></div>
        <div id="editor_tabs">      
          <ul>
            <li><a href="#tab_editor">editor</a></li>
            <li><a href="#tab_output">output</a></li>
          </ul>
          <div id="tab_editor">
            <textarea id="editor"></textarea>
          </div>
          <div id="tab_output">
            <textarea id="output"></textarea>
          </div>
        </div>
        <div id="visible_files_container">        
          <input id="file_content_for_A" value="aaaaaaaaaaa"/>
          <input id="file_content_for_B" value="bbbbbbbbbbb"/>
          <input id="file_content_for_C" value="ccccccccccc"/>

          <input id="file_caret_pos_for_A" value="1"/>
          <input id="file_caret_pos_for_B" value="2"/>
          <input id="file_caret_pos_for_C" value="3"/>

          <input id="file_scroll_top_for_A" value="1"/>
          <input id="file_scroll_top_for_B" value="2"/>
          <input id="file_scroll_top_for_C" value="3"/>

          <input id="file_scroll_left_for_A" value="1"/>
          <input id="file_scroll_left_for_B" value="2"/>
          <input id="file_scroll_left_for_C" value="3"/>
        </div>        
      </div>
    */
    var oldFilename = 'B';
    var oldContent = $cd.fileContent(oldFilename);
    assertEquals(['A', oldFilename, 'C'], $cd.filenames());
    assertEquals(oldFilename, $cd.currentFilename());
    var newFilename = 'BB';
    $cd.renameFileFromTo(oldFilename, newFilename);
    assertEquals(['A', newFilename, 'C'], $cd.filenames().sort());
    assertTrue($cd.currentFilename() == newFilename);
  },

});
