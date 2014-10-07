// global config file so each test does not need to be configured
// you can probably leave this file alone

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
