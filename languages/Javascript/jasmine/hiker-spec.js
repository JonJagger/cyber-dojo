'use strict';

let Hiker = require('./hiker.js');

describe("answer", function() {
  it("to life the universe and everything", function() {
    let hiker = new Hiker();
    expect(hiker.answer()).toEqual(42);
  });
});
