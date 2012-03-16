
var $cd = cyberDojo;

TestCase("cyberdojo-random-Tests", {
  
  "test random3() returns 3 char string": function() {
    var target = $cd.random3();
    assert(typeof target === 'string');
    assertEquals(3, target.length);
  },
  
  "test randomChar() returns all chars from randomAlphabet": function() {
    var generated = '';
    for (var n = 0; n != 1000; n++) {
        generated += $cd.randomChar();
    }
    var alphabet = $cd.randomAlphabet();
    var max = alphabet.length;
    for (var n = 0; n != max; n++) {
      var ch = alphabet.charAt(n);
      assertNotEquals(-1, generated.indexOf(ch,0));
    }
  },
  
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
