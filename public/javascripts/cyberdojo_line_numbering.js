
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

function bind_line_numbers(editor, n)
{
  n.attr('readonly', 'true');
  // Width is enough for 3 digits (up to 999) in 14pt as set in css file
  var width = 40;
  n.css('width', width + 'px');
  n.val(line_numbers);
  
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
    n.scrollTop(editor.scrollTop());   
    n.css('top', editor.offset().top + 'px');
    n.css('left', (editor.offset().left - width) + 'px');
  }  
}
