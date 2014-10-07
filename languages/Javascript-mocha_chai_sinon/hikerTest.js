'use strict';

var answer = require('./hiker.js');

describe('Assert Style: Answer', function () {
  it('to life the universe and everything', function () {
    assert.equal(answer(), 42);
  });
});
