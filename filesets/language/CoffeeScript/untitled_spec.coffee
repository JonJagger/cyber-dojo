imports = require './untitled'

describe 'jasmine-node', ->

  it 'should pass', ->
    untitled = new imports.Untitled()
    expect(untitled.answer()).toEqual 42


