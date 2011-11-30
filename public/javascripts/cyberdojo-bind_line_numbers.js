
var lineNumbers = function() {
  var lines = '1';
  for (var number = 2; number < 999; number++) {
    lines += '\r\n' + number;
  }
  return lines;  
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
