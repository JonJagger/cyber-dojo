'use strict';

let answer = require('./hiker.js');

describe('Should Style: Answer', function () {
  it('to life the universe and everything', function () {
    answer().should.equal(42);
  });
});
