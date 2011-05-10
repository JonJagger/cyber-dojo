
function createLineNumbersFor(id)
{  
  var string = '';
  for (var no = 1; no < 999; no++) 
  {
    if (string.length > 0) 
    {
      string += '\r\n';
    }
    string += no;
  }
       
  var ta = document.getElementById(id);
  var el = document.createElement('textarea'); // line-numbers textarea
  
  el.setAttribute('readonly', 'true');  
  el.id = 'line_numbers';
  el.className      = 'textarea_with_line_numbers';
  el.style.height   = (ta.offsetHeight - 3) + "px";
  el.style.position = 'absolute';
  el.style.overflow = 'hidden';
  el.style.textAlign = 'right';
  // When the textarea has the focus the browser highlights it typically by
  // adding a small extra faint margin. Counteract this by reducing the
  // margin. This means the textarea editor and its accompanying line numbers
  // have better horizontal alignment.
  el.style.marginTop       = '-1px';
  el.style.marginBottom    = '-1px';
  el.style.width    = '33px';
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
    el.style.left = (ta.offsetLeft - 37) + "px";
  }
}


