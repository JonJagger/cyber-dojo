
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
  var ta = document.getElementById('editor');
  var el = document.createElement('textarea'); // line-numbers textarea
  
  el.setAttribute('readonly', 'true');  
  el.id = 'editor_line_numbers';
  el.style.height   = (ta.offsetHeight - 3) + "px";
  
  el.style.position = 'absolute';
  el.style.overflow = 'hidden';
  el.style.textAlign = 'right';
  
  el.style.width    = '40px';
  
  el.innerHTML      = line_numbers;  // Firefox renders \n linebreak
  el.innerText      = line_numbers;  // IE6 renders \n line break
  el.value          = line_numbers;  // Safari
  
  el.style.zIndex   = 0; 
  ta.style.zIndex   = 1;
  ta.style.position = 'relative';
  ta.parentNode.insertBefore(el, ta.nextSibling);
  setLine();
  ta.focus();
       
  var move = false;
  
  $j('#editor').bind({
    scroll:     function(ev) { setLine(); },
    mousewheel: function(ev) { setLine(); }, // needed for Opera
    keydown:    function(ev) { setLine(); },
    mousedown:  function(ev) { setLine(); move = true; },
    mouseup:    function(ev) { setLine(); move = false; },
    mousemove:  function(ev) { if (move) { setLine(); }}
  });
             
  function setLine() 
  {
    el.scrollTop  = ta.scrollTop;
    el.style.top  = (ta.offsetTop) + "px";
    el.style.left = (ta.offsetLeft - 44) + "px";
  }
}


