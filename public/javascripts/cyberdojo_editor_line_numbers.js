
var move = false;

function createTextAreaWithLineNumbers(id)
{
  var el = document.createElement('TEXTAREA');
  var ta = document.getElementById(id);
       
  var string = '';
  for (var no = 1; no < 999; no++) {
    if (string.length > 0) 
      string += '\r\n';
    string += no;
  }
       
  el.setAttribute('readonly', 'true');  
  el.id = "line_numbers";
  el.className      = 'textarea_with_line_numbers';
  el.style.height   = (ta.offsetHeight-3) + "px";
  el.style.position = 'absolute';
  el.style.overflow = 'hidden';
  el.style.textAlign = 'right';
  el.style.width    = '35px';
  el.style.paddingRight = '0.2em';
  el.innerHTML      = string;  // Firefox renders \n linebreak
  el.innerText      = string;  // IE6 renders \n line break
  el.value          = string;  // Safari
  el.style.zIndex   = 0; 
  ta.style.zIndex   = 1;
  ta.style.position = 'relative';
  ta.parentNode.insertBefore(el, ta.nextSibling);
  setLine();
  ta.focus();
       
  ta.onscroll     = function() { setLine(); }
  ta.onkeydown    = function() { setLine(); }
  ta.onmousedown  = function() { setLine(); move = true; }
  ta.onmouseup    = function() { setLine(); move = false; }
  ta.onmousemove  = function() { if (move) { setLine(); } }
             
  function setLine() {
    el.scrollTop   = ta.scrollTop;
    el.style.top   = (ta.offsetTop) + "px";
    el.style.left  = (ta.offsetLeft - 37) + "px";
  }
}


