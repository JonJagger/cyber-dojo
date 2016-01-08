
class Avatar

  def initialize(kata, name)
    @kata = kata
    @name = name
  end

  # modifier

  def test(delta, files, now = time_now, max_seconds = 15)
    output = runner.run(kata.id, name, delta, files, language.image_name, max_seconds)
    test_colour = language.colour(output)
    history.avatar_ran_tests(self, delta, files, now, output, test_colour)
    [output, test_colour]
  end

  # queries

  attr_reader :kata, :name

  def parent
    kata
  end

  def language
    # Each avatar does _not_ choose their own language+test.
    # The language+test is chosen for the _dojo_.
    # cyber-dojo is a team-based Interactive Dojo Environment,
    # not an Individual Development Environment
    kata.language
  end

  def diff(was_tag, now_tag)
    history.tag_git_diff(self, was_tag, now_tag)
  end

  def active?
    # Players sometimes start an extra avatar solely to read the
    # instructions. I don't want these avatars appearing on the dashboard.
    # When forking a new kata you can enter as one animal to sanity check
    # it is ok (but not press [test])
    history.avatar_exists?(self) && !lights.empty?
  end

  def tags
    ([tag0] + increments).map { |h| Tag.new(self, h) }
  end

  def lights
    tags.select(&:light?)
  end

  def visible_filenames
    visible_files.keys
  end

  def visible_files
    history.avatar_visible_files(self)
  end

  def sandbox
    # The avatar's sandbox holds its source files
    Sandbox.new(self)
  end

  private

  include ExternalParentChainer
  include TimeNow

  def increments
    history.avatar_increments(self)
  end

  def tag0
    @zeroth ||=
    {
      'event'  => 'created',
      'time'   => time_now(kata.created),
      'number' => 0
    }
  end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo, kata.start_avatar()
# will do a 'git commit' + 'git tag' for tag 0 (zero).
# This initial tag is *not* recorded in the
# increments.json file which starts as [ ]
# It probably should be but isn't for existing dojos
# and so for backwards compatibility it stays that way.
#
# All subsequent 'git commit' + 'git tag' commands
# correspond to a gui action and store an entry in the
# increments.json file.
# eg
# [
#   {
#     'colour' => 'red',
#     'time'   => [2014, 2, 15, 8, 54, 6],
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
#    o) opening a different file
#    o) editing a file
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
# a diff between
#   avatar.tags[0] and avatar.tags[1]
#
# ------------------------------------------------------
