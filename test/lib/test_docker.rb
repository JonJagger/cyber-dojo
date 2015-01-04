#!/usr/bin/env ruby

require_relative 'lib_test_base'

class DockerTests < LibTestBase

  test 'Docker.installed?' do
    result = Docker.installed?
    assert result === true || result === false
  end

end
