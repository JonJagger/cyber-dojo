
var line_numbers = function() {
  var string = '';
  var crlf = '';
  for (var no = 1; no < 999; no++) 
  {
    string += crlf + no;
    crlf = '\r\n';
  }
  return string;  
}();

function createLineNumbersForEditor()
{         
  var editor = $j('#editor');
  var tel = $j('<textarea>');
  
  tel.attr('readonly', 'true');  
  tel.attr('id', 'editor_line_numbers');
  tel.css('height', (editor.height() - 3) + 'px');
  tel.css('position', 'absolute');
  tel.css('overflow', 'hidden');
  tel.css('text-align', 'right');  
  tel.css('width', '40px');  
  tel.html(line_numbers);  
  tel.css('z-index', 0);
  editor.css('z-index', 1);
  editor.css('position', 'relative');
  
  tel.insertBefore(editor);
  
  setLine();
  editor.focus();
       
  var move = false;
  
  editor.bind({
    scroll:     function(ev) { setLine(); },
    mousewheel: function(ev) { setLine(); }, // needed for Opera
    keydown:    function(ev) { setLine(); },
    mousedown:  function(ev) { setLine(); move = true; },
    mouseup:    function(ev) { setLine(); move = false; },
    mousemove:  function(ev) { if (move) { setLine(); }}
  });
             
  function setLine() 
  {
    tel.scrollTop(editor.scrollTop());   
    tel.css('top', editor.offset().top + 'px');
    tel.css('left', (editor.offset().left - 44) + 'px');
  }
}
