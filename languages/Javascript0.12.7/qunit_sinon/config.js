// Dummy file to run qunit used for the --code parameter
// qunit --code config.js --tests *-test.js
//         ^^^^^^^^^^^^^^
// must exist to run qunit.
// You should require your dependencies in your '*-test.js' files
// as you are used to, i.e.
// require('./hiker.js')

var chai = require('chai');
var sinonChai = require('sinon-chai');

global.sinon = require('sinon');

// although you will probably only choose one style
// assert, expect, and should are all here

global.assert = chai.assert;
global.expect = chai.expect;
global.should = chai.should(); // Note that should has to be executed

chai.config.includeStack = true;
chai.use(sinonChai);
