
var cyberDojo = (function($cd) {

  $cd.unbindLineNumbers = function(name) {
    var numbers = $j('[id="' + name + '_line_numbers"]');
    numbers.val("");    
  };
  
  $cd.bindLineNumbers = function(name) {
    var editor = $j('#' + name);
    var numbers = $j('[id="' + name + '_line_numbers"]');
    
    numbers.attr('readonly', 'true');
    numbers.val($cd.lineNumbers);
    
    editor.bind({
        scroll:     function(ev) { setLine(); },
        mousewheel: function(ev) { setLine(); },
        keydown:    function(ev) { setLine(); },
        mousedown:  function(ev) { setLine(); },
        mouseup:    function(ev) { setLine(); },
        mousemove:  function(ev) { setLine(); }
      });
    
    function setLine() {
      numbers.scrollTop(editor.scrollTop());   
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

