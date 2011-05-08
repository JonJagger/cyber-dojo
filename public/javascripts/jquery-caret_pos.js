
/*
 * Cobbled together by Jon Jagger
 */

(function($) {
  
  $.fn.getCaretPos = function() {
    var control = this[0];
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
    else if (control.selectionStart || control.selectionStart === '0')
    {
      caretPos = control.selectionStart;
    }
    return caretPos;     
  };
    
  $.fn.setCaretPos = function(pos) {
    var control = this[0];
    if (control.setSelectionRange) 
    {
      control.focus();
      control.setSelectionRange(pos, pos);
    } 
    else if (control.createTextRange) 
    {
      var range = control.createTextRange();
      range.collapse(true);
      range.move('character', pos);
      range.select();
    } 
    else
      control.focus(); 
  };  
  
})(jQuery);


















