
var lineNumbers = function() {
  var string = '';
  var crlf = '';
  for (var no = 1; no < 999; no++) 
  {
    string += crlf + no;
    crlf = '\r\n';
  }
  return string;  
}();

function bindLineNumbers(editor, numbers)
{
  numbers.attr('readonly', 'true');
  numbers.val(lineNumbers);
  
  editor.bind({
      scroll:     function(ev) { setLine(); },
      mousewheel: function(ev) { setLine(); },
      keydown:    function(ev) { setLine(); },
      mousedown:  function(ev) { setLine(); },
      mouseup:    function(ev) { setLine(); },
      mousemove:  function(ev) { setLine(); }
    });
  
  function setLine() {
    numbers.scrollTop(editor.scrollTop());   
  }  
}
