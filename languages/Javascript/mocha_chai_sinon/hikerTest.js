'use strict';

let Hiker = require('./hiker.js');

//----------------------------------------------------
// This test has nothing to do with the chosen exercise.
// It's only to help you get started.
//----------------------------------------------------

describe('Should Style: Answer', function () {
  it('to life the universe and everything', function () {
    new Hiker().answer().should.equal(42);
  });
});
