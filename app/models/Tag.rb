require 'json'
require_relative '../lib/Cleaner'

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
    clean(@git.diff(@avatar.path, command))
  end

  def light
    # tag 0 has no light
    @light
  end

private

  include Cleaner

end
