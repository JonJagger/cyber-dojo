/*jsl:option explicit*/
  
var cyberDojo = (function($cd) {

  $cd.tabber = function(file) {
    file.tabby({ tabString: $cd.tabExpansion() });
  };
    
  return $cd;
})(cyberDojo || {});
