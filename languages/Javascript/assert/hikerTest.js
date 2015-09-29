'use strict';

Hiker = require('./hiker.js');

assert = require('assert');

assert.equal(new Hiker().answer(), 42 );

console.log('All tests passed');
