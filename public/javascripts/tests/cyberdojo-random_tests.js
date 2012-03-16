
var $cd = cyberDojo;

TestCase("cyberdojo-random-Tests", {
  
  "test random3() returns 3 char string": function() {
    var target = $cd.random3();
    assert(typeof target === 'string');
    assertEquals(3, target.length);
  },
  
  "test randomChar() returns all chars from alphabet": function() {
    var generated = '';
    for (var n = 0; n != 1000; n++) {
        generated += $cd.randomChar();
    }
    var alphabet = $cd.randomAlphabet();
    for (var n = 0; n != alphabet.length; n++) {
      var ch = alphabet.charAt(n);
      assertNotEquals(-1, generated.indexOf(ch,0));
    }
  },
  
  "test rand(n) returns integer between 0 and n-1": function() {
    for (var n = 0; n != 100; n++) {
      var r = $cd.rand(6);
      assert(typeof r === 'number');
      assert(r===0 || r===1 || r===2 || r===3 || r===4 || r===5);
    }
  },
  
});
