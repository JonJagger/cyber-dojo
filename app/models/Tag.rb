
# See comment at bottom of Avatar.rb

class Tag

  def initialize(avatar,n)
    @avatar,@n = avatar,n
  end

  def visible_files
    @manifest ||= JSON.parse(git.show(@avatar.path, "#{@n}:manifest.json"))
  end

  def output
    # tag 0's manifest (start_avatar commit)
    # does not have an output file
    visible_files['output'] || ''
  end

  def diff(m)
    command = "--ignore-space-at-eol --find-copies-harder #{@n} #{m} sandbox"
    diff_lines = git.diff(@avatar.path, command)
    visible_files = @avatar.tags[m].visible_files
    git_diff(diff_lines, visible_files)
  end

private

  include ExternalGetter
  include GitDiff

end
