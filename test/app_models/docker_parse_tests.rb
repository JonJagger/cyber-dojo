__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'

class DockerParseTests < ActionController::TestCase

  test "parse 'docker ps -a' output" do
    output = [
      "ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS",
      "d93657f6b9ff        base:latest         /bin/bash -c ls -al   3 seconds ago       Exit 0          ",
      "3c639694a878        base:latest         /bin/bash -c ls -al   22 seconds ago      Exit 0          "
    ].join("\n")

    lines = output.lines.entries[1..-1]
    ids = lines.each.collect {|line| line.split[0] }
    assert_equal [ 'd93657f6b9ff', '3c639694a878' ], ids
  end

  test "parse 'docker images' output" do
    output = [
      "REPOSITORY          TAG                 ID                  CREATED             SIZE",
      "node                latest              d8c41048dc9a        6 months ago        293.3 MB (virtual 473.5 MB)",
      "base                latest              b750fe79269d        11 months ago       24.65 kB (virtual 180.1 MB)"
    ].join("\n")

    lines = output.lines.entries[1..-1]
    ids = lines.each.collect {|line| line.split[2] }
    assert_equal [ 'd8c41048dc9a', 'b750fe79269d' ], ids
  end

end
