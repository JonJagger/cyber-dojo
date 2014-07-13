root = '../..'
require_relative root + '/app/lib/Cleaner'
require 'json'

class Tags

  include Enumerable

  def initialize(avatar,git)
    @avatar,@git = avatar,git
  end

  def each
    # avatar.tags.each
    (0...count).each {|n| yield self[n] if block_given? }
  end

  def [](n)
    # avatar.tags[6]
    Tag.new(@avatar,n,@git)
  end

  def count
    tags.count
  end

  def latest
    self[count] # See comment below
  end

private

  include Cleaner

  def tags
    @tags ||= JSON.parse(clean(@avatar.dir.read('increments.json')))
  end

end

# After an avatar starts (but before the first test is
# auto-run) a git.commit(tag=0) occurs for the avatar
# and increments.json is created as [ ]
# So when there is 1 tag there are 0 lights
#
#
# After the first [test] is run the increments.json
# file contains a single light, eg
# [
#   {
#     'colour' => 'red',
#     'time' => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
# and a manifest.json file for tag=1 is created.
# So when there is 2 tags there is 1 light
#
# Viz the number of tags is always one more than
# the number of entries in increments.json
# This is because each entry in increments.json
# represents an activity causing the creation of a new
# tag from-the-current-tag.
# Thus the zero'th starting tag has no light because
# it is the base tag on which all lights are grown.
#
# Thus the inclusive upper bound for n in avatar.tags[n]
# is always the current length of increments.json
# (even if that is zero) which is also the latest tag number.
