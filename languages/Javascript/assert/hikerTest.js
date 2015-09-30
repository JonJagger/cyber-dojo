'use strict';

let Hiker  = require('./hiker.js');
let assert = require('assert');

assert.equal(new Hiker().answer(), 42 );

console.log('All tests passed');
