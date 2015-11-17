'use strict';

let answer = require('./hiker.js');

describe("answer", function() {
  it("to life the universe and everything", function() {
    expect(answer()).toEqual(42);
  });
});
