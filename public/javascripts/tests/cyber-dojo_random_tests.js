var $cd = cyberDojo;

TestCase("cyber-dojo_random_tests", {
    
  "test rand(n) returns all integers between 0 and n-1": function() {
    var generated = '';
    assertEquals('number', typeof $cd.rand(6));
    for (var n = 0; n != 1000; n++) {
      generated += $cd.rand(10);
    }
    var max = generated.length;
    for (var n = 0; n != max; n++) {
        var ch = generated.charAt(n);
        assertNotEquals(-1, "0123456789".indexOf(ch,0));
    }
  },
  
});