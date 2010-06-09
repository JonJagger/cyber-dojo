/***********************************************************
	TabEntry Library

	Required files:
	* selrange.js (http://dev.castwide.com)
	* prototype.js (http://prototypejs.org)

	Author: Fred Snyder
	Company: Castwide Technologies
	URL: http://castwide.com
	Date Created: July 3, 2008
	Last Updated: August 15, 2008

	8-15-2008	Fixed scrolling

	This file is freely distributable under an MIT license.
	The above copyright notice and this permission notice
	shall be included in all copies or substantial portions
	of the software.
	See http://dev.castwide.com for further details.

***********************************************************/

var TabEntry = new function() {
	this.enable = function(inp) {
		if (!inp) return;
		inp = $(inp);
		if (inp.selectionStart) {
			Event.observe(inp, 'keydown', downTab);
			Event.observe(inp, 'keyup', upTab);
			Event.observe(inp, 'keypress', checkTab);
		} else {
			Event.observe(inp, 'keydown', downTab);
			Event.observe(inp, 'keyup', checkTab);
		}
	}
	var downTab = function(evt) {
		if (evt.keyCode == 9) {
			Event.stop(evt);
		}
	}
	var upTab = function(evt) {
		if (evt.keyCode == 9) {
			Event.stop(evt);
		}
	}
	var checkTab = function(evt) {
		var input = Event.element(evt);
		if (evt.keyCode == 9) {
			var top = input.scrollTop;
			SelectionRange.insert(input, input.tab);
			Event.stop(evt);
			input.scrollTop = top;
		}
	}
}
