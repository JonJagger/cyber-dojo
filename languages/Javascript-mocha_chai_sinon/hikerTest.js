'use strict';

var answer = require('./hiker.js');

describe('Assert Style: Answer', function () {
  it('to life the universe and everything', function () {
    assert.equal(answer(), 42);
  });
});

describe('Expect Style: Answer', function () {
  it('to life the universe and everything', function () {
    expect(answer()).to.equal(42);
  });
});

describe('Should Style: Answer', function () {
  it('should work with should', function () {
    answer().should.equal(42);
  });
});

function hello(name, cb) {
  cb('hello ' + name);
}

describe('hello with callback', function () {
  var cb = sinon.spy();

  hello('foo', cb);

  it('should call callback with correct greeting with ' +
    'sinon + chai should',
    function () {
      //sinon with chai should
      cb.calledWith('hello foo').should.be.ok;
    });

  it('should call callback with correct greeting with ' +
    'sinon + chai expect',
    function () {
      //sinon with chai expect
      expect(cb.calledWith('hello foo')).to.be.ok;
    });

  it('should call callback with correct greeting with ' +
    'chai should + sinon + sinon-chai',
    function () {
      //sinonChai
      cb.should.have.been.calledWith('hello foo');
    });
});
