#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class DockerTests < CyberDojoTestBase

  test 'Docker.installed?' do
    result = Docker.installed?
    assert result === true || result === false
  end

end
