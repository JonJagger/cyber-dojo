imports = require './hiker'

describe 'jasmine-node', ->

  it 'life the universe and everything', ->
    hiker = new imports.Hiker()
    expect(hiker.answer()).toEqual 42
