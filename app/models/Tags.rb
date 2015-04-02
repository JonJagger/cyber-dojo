# comments at end of file

class Tags
  include Enumerable
  include ExternalParentChain

  def initialize(avatar)
    @parent = avatar
  end

  def [](n)
    n = length+n if n < 0
    Tag.new(@parent,n)
  end

  def each
    return enum_for(:each) unless block_given?
    (0...length).each { |n| yield Tag.new(self,n) }
  end

  def length
    1 + tags.length
  end

private

  def path
    @parent.path
  end

  def tags
    @tags ||= JSON.parse(dir.read('increments.json'))
  end

end


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo, kata.start_avatar()
# will do a 'git commit' + 'git tag' for tag 0 (Zero).
# This initial tag is *not* recorded in the
# increments.json file which starts as [ ]
#
# All subsequent 'git commit' + 'git tag' commands
# correspond to a gui action and store an entry in
# the increments.json file.
# eg
# [
#   {
#     'colour' => 'red',
#     'time' => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
#
# At the moment the only gui action that creates an
# increments.json file entry is a [test] event.
#
# However, I may create finer grained tags than
# just [test] events...
#    o) creating a new file
#    o) renaming a file
#    o) deleting a file
#    o) editing a file (and opening a different file)
#
# If this happens the difference between a Tag.new
# and a Light.new will be more pronounced and I will
# need something like this (where non test events
# will have a new non red/amber/green colour) ...
#
# def lights
#   rag = ['red','amber','green']
#   increments.select{ |inc|
#     rag.include?(inc.colour)
#   }.map { |inc|
#     Light.new(self,inc)
#   }
# end
#
# ------------------------------------------------------
# Invariants
#
# If the latest tag is N then increments.length == N
#
# The inclusive upper bound for n in avatar.tags[n] is
# always the current length of increments.json (even if
# that is zero) which is also the latest tag number.
#
# The inclusive lower bound for n in avatar.tags[n] is
# zero. When an animal does a diff of [1] what is run is
#   avatar.diff(0,1)
# which is a diff between
#   avatar.tags[0] and avatar.tags[1]
#

