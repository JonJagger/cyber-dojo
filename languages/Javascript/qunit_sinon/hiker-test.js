'use strict';

let Hiker = require('./hiker.js');

test("answer", function() {
    equal(new Hiker().answer(), 42, "to life the universe and everything");
});
