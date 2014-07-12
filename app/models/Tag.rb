root = '../..'
require_relative root + '/app/lib/Cleaner'
require_relative root + '/app/lib/GitDiff'
require 'json'

class Tag

  def initialize(avatar,n,git,light)
    @avatar,@n,@git,@light = avatar,n,git,light
  end

  def visible_files
    @manifest ||= JSON.parse(clean(@git.show(@avatar.path, "#{@n}:manifest.json")))
  end

  def output
    # tag 0's manifest does not have an output file
    visible_files['output'] || ''
  end

  def diff(m)
    command = "--ignore-space-at-eol --find-copies-harder #{@n} #{m} sandbox"
    diff_lines = clean(@git.diff(@avatar.path, command))
    visible_files = @avatar.tags[m].visible_files
    git_diff(diff_lines, visible_files)
  end

  def light
    # tag 0 has no light
    @light
  end

private

  include Cleaner
  include GitDiff

end
