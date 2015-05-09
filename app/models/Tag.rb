
# See comment at bottom of Avatar.rb

class Tag
  include ExternalParentChain
  
  def initialize(avatar,hash)
    @parent,@hash = avatar,hash
  end  
  
  def avatar
    @parent
  end

  def visible_files
    @manifest ||= JSON.parse(git.show(path, "#{number}:manifest.json"))
  end

  def output
    # Very early dojos didn't store output in initial commit
    visible_files['output'] || ''
  end

  def time
    # todo: times need to come from browser and use iso8601
    Time.mktime(*hash['time'])
  end

  def light?
    hash.include?('colour') || hash.include?('outcome')
  end
  
  def colour
    # todo: if this is called on tag that is not a light
    # it will raise a NoMethodError
    (hash['colour'] || hash['outcome']).to_sym
  end

  def to_json
    # This is used in differ_controller.rb
    {
      'colour' => colour,
      'time'   => time,
      'number' => number
    }
  end

  def number
    # badly named but can't rename - make private?
    hash['number']
  end

private

  attr_reader :hash      
  
  def path
    @parent.path
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
# If this happens the difference between tags and lights
# will be more pronounced.
# ------------------------------------------------------
# Invariants
#
# If the latest tag is N then
#   o) increments.length == N
#   o) tags.length == N+1
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
#------------------------------------------

