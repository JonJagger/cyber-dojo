
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
  end

  def clean(s)
    # force an encoding change - if encoding is already utf-8
    # then encoding to utf-8 is a no-op and invalid byte
    # sequences are not detected.
    s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    s = s.encode('UTF-8', 'UTF-16')
  end

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
