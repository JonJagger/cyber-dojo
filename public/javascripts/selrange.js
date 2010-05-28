/***********************************************************
	SelectionRange Library

	Author: Fred Snyder
	Company: Castwide Technologies
	URL: http://castwide.com
	Date Created: July 3, 2008

	This file is freely distributable under an MIT license.
	The above copyright notice and this permission notice
	shall be included in all copies or substantial portions
	of the software.
	See http://dev.castwide.com for further details.

***********************************************************/

var SelectionRange = new function() {
	this.set = function(input, start, end) {
		if (input.setSelectionRange) {
			input.setSelectionRange(start, end);
		} else {
			var range = input.createTextRange();
			range.collapse(true);
			range.moveStart("character", start);
			range.moveEnd("character", end - start);
			range.select();
		}
	}
	this.start = function(input) {
		if (input.setSelectionRange) {
			return input.selectionStart;
		}
		var range = document.selection.createRange();
		var inpRange = input.createTextRange();
		inpRange.collapse(true);
		inpStart = inpRange.getBookmark().charCodeAt(2) - 2;
		var isCollapsed = range.compareEndPoints("StartToEnd", range) == 0;
		if (!isCollapsed)
			range.collapse(true);
		var b = range.getBookmark();
		return b.charCodeAt(2) - 2 - inpStart;
	}
	this.end = function(input) {
		if (input.setSelectionRange) {
			return input.selectionEnd;
		}
		var range = document.selection.createRange();
		var inpRange = input.createTextRange();
		inpRange.collapse(true);
		inpStart = inpRange.getBookmark().charCodeAt(2) - 2;
		var isCollapsed = range.compareEndPoints("StartToEnd", range) == 0;
		if (!isCollapsed)
			range.collapse(false);
		var b = range.getBookmark();
		return b.charCodeAt(2) - 2 - inpStart;
	}
	this.insert = function(input, text) {
		if (input.setSelectionRange) {
			var start = input.selectionStart;
			var end = input.selectionEnd;
			input.value = input.value.substr(0, start) + text + input.value.substr(end);
			input.setSelectionRange(end + text.length, end + text.length);
		} else {
			var range = document.selection.createRange();
			range.text = text;
		}
	}
}
