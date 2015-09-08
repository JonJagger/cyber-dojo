#!/bin/bash ../test_wrapper.sh

# Idea is to give each test a unique id
# Then decorator can wrap external calls and save returned state
# in cache. Cache is named from the id. Keys in the cache are the 
# names of the method calls made and the outgoing arguments.
# All external interaction can be via bash.
# Then tests can run 
# 1. use external,   no tee (viz as per production)
# 2. use external, with tee, decorator harvests stub state and caches it
# 3. no  external, with tee, use cached stub state

# Also
# Run all the tests
# $ ./idea_test_with_id.rb
# Run only selected tests
# $ ./idea_test_with_id.rb 2ED22E
#
# Ignore coverage stats

require 'minitest/autorun'
require_relative 'TestWithId'

class EachTestHasUniqueIdToStubAgainst < MiniTest::Test

  def self.tests
    @@tests ||= TestWithId.new(self)
  end

  tests['2ED22E'].is 'abc' do
    assert_equal 1,1
  end

  tests['F01E97'].is 'def' do
    assert_equal 1,1
  end

  tests['F01E98'].is 'ghi' do
    assert_equal 1,1
  end

end
