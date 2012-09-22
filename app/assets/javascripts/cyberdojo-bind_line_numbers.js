/*jsl:option explicit*/

var cyberDojo = (function($cd) {

  $cd.lineNumbersFor = function(filename) {
    return $cd.id(filename + '_line_numbers');  
  };
  
  $cd.bindAllLineNumbers = function() {
    $j.each( $cd.filenames(), function(i,filename) {
      $cd.bindLineNumbers(filename);
    });
  };
  
  $cd.bindLineNumbers = function(filename) {
    var content = $cd.fileContentFor(filename);
    var numbers = $cd.lineNumbersFor(filename);
    
    numbers.attr('readonly', 'true');
    numbers.val($cd.lineNumbers);
    
    content.bind({
        scroll:     function(ev) { setLine(); },
        mousewheel: function(ev) { setLine(); },
        keydown:    function(ev) { setLine(); },
        mousedown:  function(ev) { setLine(); },
        mouseup:    function(ev) { setLine(); },
        mousemove:  function(ev) { setLine(); }
      });
    
    function setLine() {
      numbers.scrollTop(content.scrollTop());   
    }
  };

  $cd.lineNumbers = function() {
    var lines = '1';
    for (var number = 2; number < 999; number++) {
      lines += '\r\n' + number;
    }
    return lines;  
  }();
  
  return $cd;
})(cyberDojo || {});

