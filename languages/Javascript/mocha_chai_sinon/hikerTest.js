'use strict';

let Hiker = require('./hiker.js');

describe('Should Style: Answer', function () {
  it('to life the universe and everything', function () {
    new Hiker().answer().should.equal(42);
  });
});
