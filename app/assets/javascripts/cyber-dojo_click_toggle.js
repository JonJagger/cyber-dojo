
// http://stackoverflow.com/questions/4911577/jquery-click-toggle-between-two-functions
// $().toggle() no longer exists in JQuery
// Used in app/assets/javascripts/cyber-dojo_dialog_diff.js
// to toggle added/removed lines

$.fn.clickToggle = function(func1, func2) {
  // usedin cyber-dojo_dialog_history.js
  var funcs = [func1, func2];
  this.data('toggle_clicked', 0);
  this.click(function() {
	  var data = $(this).data();
	  var tc = data.toggle_clicked;
	  $.proxy(funcs[tc], this)();
	  data.toggle_clicked = (tc + 1) % 2;
  });
  return this;
};
