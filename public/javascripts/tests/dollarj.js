
// simulate cyberdojo/app/views/layouts/application.html.erb
var $j = jQuery.noConflict();

// simulate cyberdojo/app/view/kata/edit.html.erb
var cyberDojo = (function($cd, $j) {

  $cd.tabExpansion = function() {
    return "  ";
  };

  return $cd;
})(cyberDojo || {}, $j);
