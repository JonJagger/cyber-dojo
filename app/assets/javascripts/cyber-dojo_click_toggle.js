
// http://stackoverflow.com/questions/4911577/jquery-click-toggle-between-two-functions
// $().toggle() no longer exists in JQuery

$.fn.clickToggle = function(func1, func2) {
  var funcs = [func1, func2];
  this.data('toggleclicked', 0);
  this.click(function() {
	var data = $(this).data();
	var tc = data.toggleclicked;
	$.proxy(funcs[tc], this)();
	data.toggleclicked = (tc + 1) % 2;
  });
  return this;
};
