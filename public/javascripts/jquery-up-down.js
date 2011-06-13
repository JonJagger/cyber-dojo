// jQuery up/down selector plugin
// Author: Karl Agius
// Version: 1.0 - 16th August, 2009
// URL: http://karlagius.com/2009/08/16/an-updown-control-in-jquery/

jQuery.fn.updown = function (min, max, initial, valueChangedCallback) {
	return this.each(function () {
		target = jQuery(this);
		
		target.data("min", min);
		target.data("max", max);
		target.data("valueChangedCallback", (!valueChangedCallback) 
			? valueAttributeSetter 		// No callback was specified - use the default callback, which sets the value on an html input element.
			: valueChangedCallback);	// Use the given callback.
		
		target
			.before("<div class=\"updown updown_up button\">+</div>")		// Insert the markup for the up button.
			.prev()													// Select the newly created up button.
			.data("target", target)									// Tell the button which element it is associated with.
			.click(increment);										// Attach behaviour.
		
		target
			.after("<div class=\"updown updown_down button\">&ndash;</div>")	// Same as for the up button, see above.
			.next()
			.data("target", target)
			.click(decrement);
		
		target.data("value", initial);
		target.data("valueChangedCallback")(target);
	});
	
	function increment() {
		target = jQuery(this).data("target");
		value = target.data("value") + 1;
		
		if (value > target.data("max"))
			value = target.data("min");
			
		target.data("value", value);
		target.data("valueChangedCallback")(target);
	}
	
	function decrement() {
		target = jQuery(this).data("target");
		value = target.data("value") - 1;
		
		if (value < target.data("min"))
			value = target.data("max");
		
		target.data("value", value);
		target.data("valueChangedCallback")(target);
	}
	
	function valueAttributeSetter(target) {
		value = target.data("value");
		target[0].value = value;
	}
}
