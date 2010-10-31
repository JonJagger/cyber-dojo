

function getLiveCaretPos() 
{
  var control = $('editor');
  var caretPos = 0;
  // IE Support
  if (document.selection) 
  {
    control.focus();
    var sel = document.selection.createRange();
    sel.moveStart('character', -control.value.length);
    caretPos = sel.text.length;
  }
  // Firefox support
  else if (control.selectionStart || control.selectionStart == '0')
    caretPos = control.selectionStart;

  return caretPos;
}

function setLiveCaretPos(pos)
{
  var control = $('editor');
  if (control.setSelectionRange)
  {
    control.focus();
    control.setSelectionRange(pos, pos);
  }
  else if (control.createTextRange) 
  {
    var range = control.createTextRange();
    range.collapse(true);
    range.moveEnd('character', pos);
    range.moveStart('character', pos);
    range.select();
  }
  // Trying to use this to scroll the textarea to ensure
  // the cursor/caret position comes into view.
  // It works but only if the css style for the textarea is
  // overflow-y: hidden;
  control.scrollTop = pos;
}

