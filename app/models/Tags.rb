require 'json'
require 'Cleaner'

class Tags
  include Enumerable

  def initialize(avatar,git)
    @avatar,@git = avatar,git
  end

  def each
    # avatar.tags.each
    (0...length).each {|n| yield self[n] if block_given? }
  end

  def [](n)
    # avatar.tags[6]
    Tag.new(@avatar,n,@git)
  end

  def length
    tags.length
  end

  def latest
    self[length] # see comment below
  end

private

  def tags
    @tags ||= JSON.parse(clean(@avatar.dir.read('increments.json')))
    # This is inefficient. I only need the length
    # which is the same as the latest tag. So
    # @length ||= `cd @avatar.path;git shortlog -s`.to_i
    # which needs to go inside a new git method
    #
    # However....
    # traffic-light info (colour,time,number) from increments.json
    # is *not* currently included in a tag for two reasons
    # 1. tag[0] does not have a traffic-light
    # 2. I plan to use tags for more than traffic-lights
    #    eg new/rename/delete a file
    #    eg opening different file
    # viz
    #    avatar.lights[n]   gives you the tag for the nth traffic light
    #    avatar.tags[n]     gives you the nth tag which may not be a traffic-light.
    #
    # However, perhaps this needs revisiting.
    # Surely tags for, eg, file rename, will need time and number?

  end

  include Cleaner

end

# When an avatar starts (but before the first test
# is auto -run) a git.commit(tag=0) occurs for it.
# This creates an increments.json file which is [ ]
# because there are no lights yet.
# It also creates a manifest.json file at tag=0 which
# can be read with git.show(path,'0:manifest.json').
#
# When the first [test] is run the increments.json
# file contains a single light, eg
# [
#   {
#     'colour' => 'red',
#     'time' => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
# and a manifest.json file for tag=1 is created.
#
# Thus the inclusive upper bound for n in avatar.tags[n]
# is always the current length of increments.json
# (even if that is zero) which is also the latest tag number.
