#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class MemoryLogTest < LibTestBase

  test '3F6D7F',
  'log is initially empty' do
    log = MemoryLog.new(dummy = nil)
    refute log.include? 'anything'
    assert_equal '[]', log.to_s
  end

  # - - - - - - - - - - - - - - -

  test '734E69',
  'log contains inserted message' do
    log = MemoryLog.new(dummy = nil)
    log << 'something'
    assert log.include? 'something'
    assert_equal '["something"]', log.to_s
  end

end
